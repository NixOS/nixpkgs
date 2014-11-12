{pkgs,...}:
{
  ###### interface
  options = {
    forward = {
      default = "<TAB>";
      description = "Keymap to trigger completion, and to cycle in forward direction.";
    };
    
    backward = {
      default = "<S-TAB>";
      description = "Keymap to cycle in backward direction.";
    };
    
    literal = {
      default = "<C-TAB>";
      description = "Keymap to insert a literal TAB.";
    };

    listSnippets = {
      default = "<C-S-TAB>";
      description = "Keymap to list all snippets of UltiSnip.";
    };

    force = {
      default = "<C-Space>";
      description = "Keymap to invoce semantic completion of YouCompleteMe.";
    };
  };


  ###### implementation
  vimrc = cfg: if !(isNull cfg.forward) || !(isNull cfg.backward)
    then ''
      " trigger supertab mapping
      let g:SuperTabMappingForward = '${cfg.forward}'
      let g:SuperTabMappingBackward = '${cfg.backward}'
      
      " tune supertab
      let g:SuperTabRetainCompletionDuration = 'completion'
      let g:SuperTabNoCompleteBefore = ['\t']
      let g:SuperTabNoCompleteAfter = ['^', '\s', '\t']
      let g:SuperTabClosePreviewOnPopupClose = 1
      " literal tab
      ''
      + (if (isNull cfg.literal) then "" else "let g:SuperTabMappingTabLiteral = '${cfg.literal}'") +
      ''
      " enable next-longest matching support
      let g:SuperTabLongestEnhanced = 1
      
      " couple supertab to YCM
      let g:SuperTabDefaultCompletionType = '<C-p>'
      let g:ycm_key_list_select_completion = ['<C-n>']
      let g:ycm_key_list_previous_completion = ['<C-p>']
      let g:ycm_key_invoke_completion = '${if isNull cfg.force then "" else cfg.force}'
      
      " match ultisnips
      let g:UltiSnipsExpandTrigger = '${cfg.forward}'
      let g:UltiSnipsJumpForwardTrigger = '${cfg.forward}'
      let g:UltiSnipsJumpBackwardTrigger = '${cfg.backward}'

      " config YCM
      let g:ycm_seed_identifiers_with_syntax = 1
      " ctags needs to be called with --fields=+l, and tagsfiles come from tagfiles()
      let g:ycm_collect_identifiers_from_tags_files = 1
      let g:ycm_autoclose_preview_window_after_completion = 1
      let g:ycm_autoclose_preview_window_after_insertion = 1
      ''
      + (if (isNull cfg.listSnippets) then "" else "let g:UltiSnipsListSnippets = '${cfg.listSnippets}'")
    else "";

  plugins = [ "supertab" "YouCompleteMe" "ultisnips" ];

  paths = [ pkgs.python ];
}

