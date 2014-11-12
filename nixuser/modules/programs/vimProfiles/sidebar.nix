{pkgs, ...}:
{
  ###### interface
  options = {
    toggleUndo = {
      default = "<Leader>tu";
      description = "Keymap to toggle undo sidebar.";
    };

    toggleTag = {
      default = "<Leader>tt";
      description = "Keymap to toggle tags sidebar.";
    };

    toggleFile = {
      default = "<Leader>tf";
      description = "Keymap to toggle file tree sidebar.";
    };
  };


  ###### implementation
  vimrc = cfg:
    ''
    " Add a bit extra margin to the left
    set foldcolumn=1

    '' + (if isNull cfg.toggleUndo then "" else ''
    " Show undo tree
    nmap <silent> ${cfg.toggleUndo} :GundoToggle<CR>

    '') + (if isNull cfg.toggleTag then "" else ''
    " Show tags
    map ${cfg.toggleTag} :TagbarToggle<CR>
    '') + ''

    " NERDTree
    " Close nerdtree after a file is selected
    let NERDTreeQuitOnOpen = 1

    '' + (if isNull cfg.toggleFile then "" else ''
    function! IsNERDTreeOpen()
      return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
    endfunction

    function! ToggleFindNerd()
      if IsNERDTreeOpen()
        exec ':NERDTreeToggle'
      else
        exec ':NERDTreeFind'
      endif
    endfunction

    " If nerd tree is closed, find current file, if open, close it
    nmap <silent> ${cfg.toggleFile} :call ToggleFindNerd()<CR>
    '');

  plugins = [ "nerdtree" "tagbar" "gundo" ];

  paths = [];
}

