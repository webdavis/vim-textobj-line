runtime! plugin/textobj/line.vim

function! s:check(move_cmd, op_cmd, expected_value)
  let @0 = '*nothing yanked*'
  execute 'normal!' a:move_cmd
  execute 'normal' a:op_cmd
  Expect @0 ==# a:expected_value
endfunction




describe '<Plug>(textobj-line-select-a)'
  before
    new
  end

  after
    close!
  end

  it 'selects all characters in the current line but the end of line'
    silent 1 put! =['', '   foo bar baz   ', '', 'x', '', '   ', '', '', '']

    call s:check('2gg0', 'vaLy', '   foo bar baz   ')
    call s:check('2gg0', 'yaL', '   foo bar baz   ')
    call s:check('2gg0ww', 'vaLy', '   foo bar baz   ')
    call s:check('2gg0ww', 'yaL', '   foo bar baz   ')
    call s:check('4gg0', 'vaLy', 'x')
    call s:check('4gg0', 'yaL', 'x')
    call s:check('6gg2|', 'vaLy', '   ')
    call s:check('6gg2|', 'yaL', '   ')
    call s:check('8gg0', 'vaLy', "\n")  " NB: Cannot select empty text in Visual mode.
    call s:check('8gg0', 'yaL', '')
  end
end




describe '<Plug>(textobj-line-select-i)'
  before
    new
  end

  after
    close!
  end

  it 'selects all characters in the current line but surrounding spaces'
    silent 1 put! =['', '   foo bar baz   ', '', 'x', '', '   ', '', '', '']

    call s:check('2gg0', 'viLy', 'foo bar baz')
    call s:check('2gg0', 'yiL', 'foo bar baz')
    call s:check('2gg0ww', 'viLy', 'foo bar baz')
    call s:check('2gg0ww', 'yiL', 'foo bar baz')
    call s:check('4gg0', 'viLy', 'x')
    call s:check('4gg0', 'yiL', 'x')
    call s:check('6gg2|', 'viLy', ' ')  " NB: Cannot select empty text in Visual mode.
    call s:check('6gg2|', 'yiL', '')
    call s:check('8gg0', 'viLy', "\n")  " NB: Cannot select empty text in Visual mode.
    call s:check('8gg0', 'yiL', '')
  end
end
