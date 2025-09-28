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
    old: info: throw "${old} was renamed to ${info.new} on ${info.date}. Please update to ${info.new}."
  ) (lib.importJSON ./deprecated.json);

in
mapAliases (
  with prev;
  {
    airline = vim-airline;
    alternative = a-vim; # backwards compat, added 2014-10-21
    bats = bats-vim;
    blueballs-neovim = throw "`blueballs-neovim` has been removed"; # added 2025-06-17
    BufOnly = BufOnly-vim;
    calendar = calendar-vim;
    coffee-script = vim-coffee-script;
    coffeeScript = vim-coffee-script; # backwards compat, added 2014-10-18
    Solarized = vim-colors-solarized;
    solarized = vim-colors-solarized;
    spacevim = throw "this distribution was unmaintained for the last 6 years, please use top-level 'spacevim'"; # added 2024-11-27
    SpaceVim = throw "this distribution didn't work properly in vimPlugins, please use top-level 'spacevim' instead"; # added 2024-11-27
    sparkup = throw "the upstream repository got deleted"; # added 2025-08-06
    colors-solarized = vim-colors-solarized;
    caw = caw-vim;
    chad = chadtree;
    colorsamplerpack = Colour-Sampler-Pack;
    Colour_Sampler_Pack = Colour-Sampler-Pack;
    command_T = command-t; # backwards compat, added 2014-10-18
    commentary = vim-commentary;
    committia = committia-vim;
    concealedyank = concealedyank-vim;
    context-filetype = context_filetype-vim;
    Cosco = cosco-vim;
    css_color_5056 = vim-css-color;
    CSApprox = csapprox;
    csv = csv-vim;
    ctrlp = ctrlp-vim;
    cute-python = vim-cute-python;
    denite = denite-nvim;
    easy-align = vim-easy-align;
    easygit = vim-easygit;
    easymotion = vim-easymotion;
    echodoc = echodoc-vim;
    eighties = vim-eighties;
    extradite = vim-extradite;
    feline-nvim = throw "feline.nvim has been removed: upstream deleted repository. Consider using lualine"; # Added 2025-02-09
    fugitive = vim-fugitive;
    floating-nvim = throw "floating.nvim has been removed: abandoned by upstream. Use popup-nvim or nui-nvim"; # Added 2024-11-26
    fzfWrapper = fzf-wrapper;
    ghc-mod-vim = ghcmod-vim;
    ghcmod = ghcmod-vim;
    gleam-vim = throw "gleam.vim has been removed: its code was merged into vim."; # Added 2025-06-10
    goyo = goyo-vim;
    Gist = vim-gist;
    gitgutter = vim-gitgutter;
    gundo = gundo-vim;
    Gundo = gundo-vim; # backwards compat, added 2015-10-03
    haskellConceal = vim-haskellconceal; # backwards compat, added 2014-10-18
    haskellConcealPlus = vim-haskellConcealPlus;
    haskellconceal = vim-haskellconceal;
    hier = vim-hier;
    hlint-refactor = hlint-refactor-vim;
    hoogle = vim-hoogle;
    Hoogle = vim-hoogle;
    indent-blankline-nvim-lua = indent-blankline-nvim; # backwards compat, added 2021-07-05
    ipython = vim-ipython;
    latex-live-preview = vim-latex-live-preview;
    maktaba = vim-maktaba;
    minsnip-nvim = throw "the upstream repository got deleted"; # added 2025-08-30
    multiple-cursors = vim-multiple-cursors;
    necoGhc = neco-ghc; # backwards compat, added 2014-10-18
    neocomplete = neocomplete-vim;
    neoinclude = neoinclude-vim;
    neomru = neomru-vim;
    neosnippet = neosnippet-vim;
    neuron-nvim = throw "neuron.nvim has been removed: archived repository 2023-02-19"; # Added 2025-09-10
    nvim-ts-rainbow = throw "nvim-ts-rainbow has been deprecated: Use rainbow-delimiters-nvim"; # Added 2023-11-30
    nvim-ts-rainbow2 = throw "nvim-ts-rainbow2 has been deprecated: Use rainbow-delimiters-nvim"; # Added 2023-11-30
    The_NERD_Commenter = nerdcommenter;
    The_NERD_tree = nerdtree;
    open-browser = open-browser-vim;
    pathogen = vim-pathogen;
    peskcolor-vim = throw "peskcolor-vim has been removed: abandoned by upstream"; # Added 2024-08-23
    polyglot = vim-polyglot;
    prettyprint = vim-prettyprint;
    quickrun = vim-quickrun;
    rainbow_parentheses = rainbow_parentheses-vim;
    repeat = vim-repeat;
    riv = riv-vim;
    rhubarb = vim-rhubarb;
    sensible = vim-sensible;
    signature = vim-signature;
    snipmate = vim-snipmate;
    sourcemap = sourcemap-vim;
    "sourcemap.vim" = sourcemap-vim;
    Spacegray-vim = throw "Spacegray-vim has been removed: abandoned by upstream"; # Added 2025-03-24
    surround = vim-surround;
    sleuth = vim-sleuth;
    solidity = vim-solidity;
    ssr = ssr-nvim; # Added 2025-08-31
    stylish-haskell = vim-stylish-haskell;
    stylishHaskell = vim-stylish-haskell; # backwards compat, added 2014-10-18
    suda-vim = vim-suda; # backwards compat, added 2024-05-16
    Supertab = supertab;
    Syntastic = syntastic;
    SyntaxRange = vim-SyntaxRange;
    table-mode = vim-table-mode;
    taglist = taglist-vim;
    tabpagebuffer = tabpagebuffer-vim;
    tabpagecd = vim-tabpagecd;
    Tabular = tabular;
    Tagbar = tagbar;
    thumbnail = thumbnail-vim;
    tlib = tlib_vim;
    tmux-navigator = vim-tmux-navigator;
    tmuxNavigator = vim-tmux-navigator; # backwards compat, added 2014-10-18
    todo-nvim = throw "todo-nvim has been removed: abandoned by upstream"; # Added 2023-08-23
    tslime = tslime-vim;
    unite = unite-vim;
    UltiSnips = ultisnips;
    vim-addon-vim2nix = vim2nix;
    vim-sourcetrail = throw "vim-sourcetrail has been removed: abandoned by upstream"; # Added 2022-08-14
    vimproc = vimproc-vim;
    vimshell = vimshell-vim;
    vinegar = vim-vinegar;
    watchdogs = vim-watchdogs;
    WebAPI = webapi-vim;
    wombat256 = wombat256-vim; # backwards compat, added 2015-7-8
    yankring = YankRing-vim;
    Yankring = YankRing-vim;
    xterm-color-table = xterm-color-table-vim;
    zeavim = zeavim-vim;
  }
  // deprecations
)
