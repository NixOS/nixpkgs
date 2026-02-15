# Deprecated aliases - for backward compatibility
lib:

final: prev:

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations =
    alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: if lib.isDerivation alias then lib.dontDistribute alias else alias;

  # Make sure that we are not shadowing something from
  # all-packages.nix.
  checkInPkgs =
    n: alias: if builtins.hasAttr n prev then throw "Alias ${n} is still in vim-plugins" else alias;

  mapAliases =
    aliases:
    lib.mapAttrs (
      n: alias: removeDistribute (removeRecurseForDerivations (checkInPkgs n alias))
    ) aliases;

  deprecations = lib.mapAttrs (
    old: info:
    lib.warnOnInstantiate "'vimPlugins.${old}' was renamed to 'vimPlugins.${info.new}' on ${info.date}. Please update to 'vimPlugins.${info.new}'." (
      builtins.getAttr info.new prev
    )
  ) (lib.importJSON ./deprecated.json);

in
mapAliases (
  with prev;
  {
    # keep-sorted start case=no
    blueballs-neovim = throw "`blueballs-neovim` has been removed"; # added 2025-06-17
    coc-go = throw "`vimPlugins.coc-go` was removed, as it was unmaintained"; # added 2026-02-12
    coc-rls = throw "coc-rls has been removed, as rls has been archived since 2022. You should use coc-rust-analyzer instead, as rust-analyzer is maintained."; # added 2025-10-01
    coc-sumneko-lua = throw "'vimPlugins.coc-sumneko-lua' was removed, as it is unmaintained and broken. You should switch to lua_ls"; # added 2026-02-04
    coc-tsserver = throw "`vimPlugins.coc-tsserver` was removed, as it was unmaintained"; # added 2026-02-12
    coc-vetur = throw "coc-vetur was removed, as vetur is unmaintained by Vue. You should switch to Volar, which supports Vue 3"; # added 2025-10-01
    completion-treesitter = throw "completion-treesitter has been archived since 2024-01"; # Added 2025-12-18
    ctags-lsp-nvim = throw "`vimPlugins.ctags-lsp-nvim` has been removed, upstream deleted the repository"; # added 2026-02-14
    feline-nvim = throw "feline.nvim has been removed: upstream deleted repository. Consider using lualine"; # Added 2025-02-09
    floating-nvim = throw "floating.nvim has been removed: abandoned by upstream. Use popup-nvim or nui-nvim"; # Added 2024-11-26
    fruzzy = throw "vimPlugins.fruzzy did not update since 2019-10-28 and uses EOL version of Nim"; # Added 2025-11-12
    gleam-vim = throw "gleam.vim has been removed: its code was merged into vim."; # Added 2025-06-10
    minsnip-nvim = throw "the upstream repository got deleted"; # added 2025-08-30
    neuron-nvim = throw "neuron.nvim has been removed: archived repository 2023-02-19"; # Added 2025-09-10
    nvim-gps = throw "nvim-gps has been archived since 2022. Use nvim-navic instead."; # Added 2025-12-18
    nvim-ts-rainbow = throw "nvim-ts-rainbow has been deprecated: Use rainbow-delimiters-nvim"; # Added 2023-11-30
    nvim-ts-rainbow2 = throw "nvim-ts-rainbow2 has been deprecated: Use rainbow-delimiters-nvim"; # Added 2023-11-30
    peskcolor-vim = throw "peskcolor-vim has been removed: abandoned by upstream"; # Added 2024-08-23
    playground = throw "playground has been archived"; # Added 2025-12-18
    pure-lua = lib.warnOnInstantiate "Please replace 'vimPlugins.pure-lua' with 'vimPlugins.moonlight-nvim' as this name was an error" moonlight-nvim; # Added 2025-11-17
    rust-tools-nvim = lib.warnOnInstantiate "'vimPlugins.rust-tools-nvim' is abandoned by upstream; you should use 'vimPlugins.rustaceanvim'" rust-tools-nvim;
    Spacegray-vim = throw "'vimPlugins.Spacegray-vim' has been removed: abandoned by upstream"; # Added 2025-03-24
    SpaceVim = throw "this distribution didn't work properly in vimPlugins, please use top-level 'spacevim' instead"; # added 2024-11-27
    spacevim = throw "this distribution was unmaintained for the last 6 years, please use top-level 'spacevim'"; # added 2024-11-27
    sparkup = throw "'vimPlugins.sparkup' was removed: the upstream repository got deleted"; # added 2025-08-06
    syntax-tree-surfer = throw "'vimPlugins.syntax-tree-surfer' has been archived"; # Added 2025-12-18
    todo-nvim = throw "'vimPlugins.todo-nvim' has been removed: abandoned by upstream"; # Added 2023-08-23
    vim-sourcetrail = throw "'vimPlugins.vim-sourcetrail' has been removed: abandoned by upstream"; # Added 2022-08-14
    # keep-sorted end
  }
  // deprecations
)
