{pkgs,...}:
{
  ###### interface
  options = {
    symbol = {
      default = "<Leader>ss";
      description = "Find all references to the token under cursor.";
    };
    
    global = {
      default = "<Leader>sg";
      description = "Find global definition(s) of the token under cursor.";
    };
    
    calls = {
      default = "<Leader>sc";
      description = "Find all calls to the function name under cursor.";
    };
    
    text = {
      default = "<Leader>st";
      description = "Find all instances of the text under cursor.";
    };
    
    egrep = {
      default = "<Leader>se";
      description = "Egrep search for the word under cursor.";
    };
    
    file = {
      default = "<Leader>sf";
      description = "Open the filename under cursor.";
    };
    
    includes = {
      default = "<Leader>si";
      description = "Find files that include the filename under cursor.";
    };
    
    called = {
      default = "<Leader>sd";
      description = "Find functions that function under cursor calls.";
    };
    
    fuzzy = {
      default = "<Leader>s<space>";
      description = "Fuzzy find files.";
    };

    selectionForward = {
      default = "<Leader>*";
      description = "Visual mode forward search for the current selection.";
    };

    selectionBackward = {
      default = "<Leader>#";
      description = "Visual mode backward search for the current selection.";
    };
  };


  ###### implementation

  vimrc = cfg: ''
    " Turn on the WiLd menu
    set wildmenu
    " Tab-complete files up to longest unambiguous prefix
    set wildmode=list:longest,full
    
    " Ignore compiled files
    set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*
    
    " Ignore case when searching
    set ignorecase
    
    " When searching try to be smart about cases 
    set smartcase
    
    " Highlight search results
    set hlsearch
    
    " Makes search act like search in modern browsers
    set incsearch
    
    " Show matching brackets when text indicator is over them
    set showmatch
    " How many tenths of a second to blink when matching brackets
    set mat=2
    

    '' + (if isNull cfg.fuzzy then "" else ''
    " Fuzzy find files
    nnoremap <silent> ${cfg.fuzzy} :CtrlP<CR>
    '') + ''
    let g:ctrlp_max_files=0
    
    " For regular expressions turn magic on
    set magic
    
    
    
    '' + (if !((isNull cfg.selectionForward) || (isNull cfg.selectionBackward)) then "" else ''
    " Visual mode pressing * or # searches for the current selection
    " From an idea by Michael Naumann

    function! VisualSelection(direction, extra_filter) range
      let l:saved_reg = @"
      execute "normal! vgvy"
    
      let l:pattern = escape(@", '\\/.*$^~[]')
      let l:pattern = substitute(l:pattern, "\n$", "", "")
    
      if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
      elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.' . a:extra_filter)
      elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
      elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
      endif
    
      let @/ = l:pattern
      let @" = l:saved_reg
    endfunction
    '') + ''

    '' + (if isNull cfg.selectionForward then "" else ''
    " Forward search for current selection
    vnoremap <silent> ${cfg.selectionForward} :call VisualSelection('f', "")<CR>
    '') + (if isNull cfg.selectionBackward then "" else ''
    " Forward search for current selection
    vnoremap <silent> ${cfg.selectionBackward} :call VisualSelection('b', "")<CR>
    '') + ''



    " General CScope and CTags search settings
    " detailed, e.g. language specific settings are defined in the corresponding Nix configured modules
    
    " use both cscope and ctag
    set cscopetag
    " search ctags first
    set cscopetagorder=1 
    set csverb

    '' + (if isNull cfg.symbol then "" else ''
    " Cscope/Ctags search for symbol or reference
    nnoremap <silent> ${cfg.symbol} :cs find s <C-R>=expand("<cword>")<CR><CR>	
    '') + (if isNull cfg.global then "" else ''
    " Cscope/Ctags search for global definition
    nnoremap <silent> ${cfg.global} :cs find g <C-R>=expand("<cword>")<CR><CR>	
    '') + (if isNull cfg.calls then "" else ''
    " Cscope/Ctags search for calls to function name
    nnoremap <silent> ${cfg.calls} :cs find c <C-R>=expand("<cword>")<CR><CR>	
    '') + (if isNull cfg.text then "" else ''
    " Cscope/Ctags search for instances of text
    nnoremap <silent> ${cfg.text} :cs find t <C-R>=expand("<cword>")<CR><CR>	
    '') + (if isNull cfg.egrep then "" else ''
    " Cscope/Ctags egrep search for text
    nnoremap <silent> ${cfg.egrep} :cs find e <C-R>=expand("<cword>")<CR><CR>	
    '') + (if isNull cfg.file then "" else ''
    " Cscope/Ctags open file
    nnoremap <silent> ${cfg.file} :cs find f <C-R>=expand("<cword>")<CR><CR>	
    '') + (if isNull cfg.includes then "" else ''
    " Cscope/Ctags find files that include filename
    nnoremap <silent> ${cfg.includes} :cs find i ^<C-R>=expand("<cword>")<CR>$<CR>	
    '') + (if isNull cfg.called then "" else ''
    " Cscope/Ctags search for functions called by function
    nnoremap <silent> ${cfg.called} :cs find d <C-R>=expand("<cword>")<CR><CR>	
    '');

  plugins = [ "ctrlp"  ];

  paths = [];
}



