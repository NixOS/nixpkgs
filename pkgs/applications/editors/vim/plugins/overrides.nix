{
  lib,
  stdenv,
  # nixpkgs functions
  buildGoModule,
  buildVimPlugin,
  callPackage,
  fetchFromGitHub,
  fetchFromSourcehut,
  fetchpatch,
  fetchurl,
  neovimUtils,
  replaceVars,
  symlinkJoin,
  # Language dependencies
  fetchYarnDeps,
  mkYarnModules,
  python3,
  # Misc dependencies
  coc-clangd,
  coc-css,
  coc-diagnostic,
  coc-pyright,
  coc-toml,
  code-minimap,
  dasht,
  deno,
  direnv,
  fzf,
  gawk,
  himalaya,
  htop,
  jq,
  khard,
  languagetool,
  libgit2,
  llvmPackages,
  meson,
  neovim-unwrapped,
  nim1,
  nodePackages,
  nodejs,
  notmuch,
  openscad,
  openssh,
  parinfer-rust,
  phpactor,
  ranger,
  ripgrep,
  skim,
  sqlite,
  sshfs,
  statix,
  stylish-haskell,
  tabnine,
  taskwarrior2,
  taskwarrior3,
  tmux,
  tup,
  typescript,
  typescript-language-server,
  vim,
  which,
  xdg-utils,
  xdotool,
  xkb-switch,
  xorg,
  xxd,
  ycmd,
  zathura,
  zenity,
  zoxide,
  zsh,
  # codeium-nvim dependencies
  codeium,
  # command-t dependencies
  getconf,
  ruby,
  # cornelis dependencies
  cornelis,
  # cpsm dependencies
  boost,
  cmake,
  icu,
  ncurses,
  # Preview-nvim dependencies
  md-tui,
  # sved dependencies
  glib,
  gobject-introspection,
  wrapGAppsHook3,
  writeText,
  curl,
  # vim-agda dependencies
  agda,
  # vim-go dependencies
  asmfmt,
  delve,
  errcheck,
  go-motion,
  go-tools,
  gocode-gomod,
  godef,
  gogetdoc,
  golangci-lint,
  golint,
  gomodifytags,
  gopls,
  gotags,
  gotools,
  iferr,
  impl,
  reftools,
  revive,
  # hurl dependencies
  hurl,
  # must be lua51Packages
  luajitPackages,
  aider-chat,
  # typst-preview dependencies
  tinymist,
  websocat,
}:
self: super:
let
  luaPackages = neovim-unwrapped.lua.pkgs;
in
{
  corePlugins = symlinkJoin {
    name = "core-vim-plugins";
    paths = with self; [
      # plugin managers
      lazy-nvim
      mini-deps
      packer-nvim
      vim-plug

      # core dependencies
      plenary-nvim

      # popular plugins
      mini-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter
      vim-airline
      vim-fugitive
      vim-surround
    ];

    meta = {
      description = "Collection of popular vim plugins (for internal testing purposes)";
    };
  };

  #######################
  # Regular overrides

  aerial-nvim = super.aerial-nvim.overrideAttrs {
    # optional dependencies
    nvimSkipModule = [
      "lualine.components.aerial"
      "telescope._extensions.aerial"
    ];
  };

  advanced-git-search-nvim = super.advanced-git-search-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      vim-fugitive
      vim-rhubarb
      fzf-lua
      plenary-nvim
    ];
  };

  agitator-nvim = super.agitator-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      plenary-nvim
    ];
  };

  astrocore = super.astrocore.overrideAttrs {
    dependencies = [ self.lazy-nvim ];
  };

  astroui = super.astroui.overrideAttrs {
    # Readme states that astrocore is an optional dependency
    checkInputs = [ self.astrocore ];
  };

  asyncrun-vim = super.asyncrun-vim.overrideAttrs {
    nvimSkipModule = [
      # vim plugin with optional toggleterm integration
      "asyncrun.toggleterm"
      "asyncrun.toggleterm2"
    ];
  };

  animation-nvim = super.animation-nvim.overrideAttrs {
    dependencies = [ self.middleclass ];
  };

  autosave-nvim = super.autosave-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  auto-session = super.auto-session.overrideAttrs {
    # optional telescope dependency
    nvimSkipModule = [
      "auto-session.session-lens.actions"
      "auto-session.session-lens.init"
      "telescope._extensions.session-lens"
    ];
  };

  avante-nvim = callPackage ./non-generated/avante-nvim { };

  aw-watcher-vim = super.aw-watcher-vim.overrideAttrs {
    patches = [
      (replaceVars ./patches/aw-watcher-vim/program_paths.patch {
        curl = lib.getExe curl;
      })
    ];
  };

  bamboo-nvim = super.bamboo-nvim.overrideAttrs {
    nvimSkipModule = [
      # Requires config table
      "bamboo.colors"
      "bamboo.terminal"
      "bamboo.highlights"
      "bamboo-light"
      "bamboo-vulgaris"
      "bamboo-multiplex"
      # Optional modules
      "lualine.themes.bamboo"
      "barbecue.theme.bamboo"
    ];
  };

  barbar-nvim = super.barbar-nvim.overrideAttrs {
    # nvim-web-devicons dependency
    nvimSkipModule = "bufferline.utils";
  };

  barbecue-nvim = super.barbecue-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-lspconfig
      nvim-navic
    ];
    meta = {
      description = "VS Code like winbar for Neovim";
      homepage = "https://github.com/utilyre/barbecue.nvim";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ lightquantum ];
    };
  };

  base46 = super.base46.overrideAttrs {
    dependencies = [ self.nvchad-ui ];
    # Requires global config setup
    nvimSkipModule = [
      "nvchad.configs.cmp"
      "nvchad.configs.gitsigns"
      "nvchad.configs.luasnip"
      "nvchad.configs.mason"
      "nvchad.configs.nvimtree"
      "nvchad.configs.telescope"
    ];
  };

  # The GitHub repository returns 404, which breaks the update script
  bitbake-vim = buildVimPlugin {
    pname = "bitbake.vim";
    version = "2021-02-06";
    src = fetchFromGitHub {
      owner = "sblumentritt";
      repo = "bitbake.vim";
      rev = "faddca1e8768b10c80ee85221fb51a560df5ba45";
      sha256 = "1hfly2vxhhvjdiwgfz58hr3523kf9z71i78vk168n3kdqp5vkwrp";
    };
    meta.homepage = "https://github.com/sblumentritt/bitbake.vim/";
  };

  blink-cmp = callPackage ./non-generated/blink-cmp { };

  blink-cmp-copilot = super.blink-cmp-copilot.overrideAttrs {
    dependencies = [ self.copilot-lua ];
  };

  blink-cmp-dictionary = super.blink-cmp-dictionary.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  blink-emoji-nvim = super.blink-emoji-nvim.overrideAttrs {
    dependencies = [ self.blink-cmp ];
  };

  blink-cmp-git = super.blink-cmp-git.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  bluloco-nvim = super.bluloco-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
  };

  bufferline-nvim = super.bufferline-nvim.overrideAttrs {
    # depends on bufferline.lua being loaded first
    nvimSkipModule = [ "bufferline.commands" ];
  };

  bufresize-nvim = super.bufresize-nvim.overrideAttrs {
    meta.license = lib.licenses.mit;
  };

  catppuccin-nvim = super.catppuccin-nvim.overrideAttrs {
    nvimSkipModule = [
      "catppuccin.groups.integrations.noice"
      "catppuccin.groups.integrations.feline"
      "catppuccin.lib.vim.init"
    ];
  };

  ccc-nvim = super.ccc-nvim.overrideAttrs {
    # ccc auto-discover requires all pass
    # but there's a bootstrap module that hangs forever if we dont stop on first success
    nvimSkipModule = "ccc.kit.Thread.Server._bootstrap";
  };

  chadtree = super.chadtree.overrideAttrs {
    buildInputs = [
      python3
    ];
    passthru.python3Dependencies =
      ps: with ps; [
        pynvim-pp
        pyyaml
        std2
      ];
    # We need some patches so it stops complaining about not being in a venv
    patches = [ ./patches/chadtree/emulate-venv.patch ];
  };

  ChatGPT-nvim = super.ChatGPT-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      plenary-nvim
      telescope-nvim
    ];
  };

  cheatsheet-nvim = super.cheatsheet-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      plenary-nvim
    ];
  };

  clangd_extensions-nvim = callPackage ./non-generated/clangd_extensions-nvim { };

  clang_complete = super.clang_complete.overrideAttrs {
    # In addition to the arguments you pass to your compiler, you also need to
    # specify the path of the C++ std header (if you are using C++).
    # These usually implicitly set by cc-wrapper around clang (pkgs/build-support/cc-wrapper).
    # The linked ruby code shows generates the required '.clang_complete' for cmake based projects
    # https://gist.github.com/Mic92/135e83803ed29162817fce4098dec144
    preFixup =
      ''
        substituteInPlace "$out"/plugin/clang_complete.vim \
          --replace-fail "let g:clang_library_path = ''
      + "''"
      + ''
        " "let g:clang_library_path='${lib.getLib llvmPackages.libclang}/lib/libclang.so'"

              substituteInPlace "$out"/plugin/libclang.py \
                --replace-fail "/usr/lib/clang" "${llvmPackages.clang.cc}/lib/clang"
      '';
  };

  clighter8 = super.clighter8.overrideAttrs {
    preFixup = ''
      sed "/^let g:clighter8_libclang_path/s|')$|${lib.getLib llvmPackages.clang.cc}/lib/libclang.so')|" \
        -i "$out"/plugin/clighter8.vim
    '';
  };

  clipboard-image-nvim = super.clipboard-image-nvim.overrideAttrs {
    postPatch = ''
      sed -i -e 's/require "health"/vim.health/' lua/clipboard-image/health.lua
    '';
  };

  cmake-tools-nvim = super.cmake-tools-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  cmd-parser-nvim = super.cmd-parser-nvim.overrideAttrs {
    # Has cmd-parser.init.test matched from lua/cmd-parser/init.test.lua
    # Can't be required and is only other module
    nvimRequireCheck = "cmd-parser";
  };

  cmp-ai = super.cmp-ai.overrideAttrs {
    # We dont want to bundle nvim-cmp anymore since blink.nvim can use these sources.
    # Add to check inputs though to validate plugin
    checkInputs = [ self.nvim-cmp ];
    dependencies = with self; [
      plenary-nvim
    ];
  };

  cmp-async-path = callPackage ./non-generated/cmp-async-path { };

  cmp-beancount = super.cmp-beancount.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-clippy = super.cmp-clippy.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = with self; [
      plenary-nvim
    ];
  };

  cmp-cmdline = super.cmp-cmdline.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-conjure = super.cmp-conjure.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.conjure ];
  };

  cmp-copilot = super.cmp-copilot.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.copilot-vim ];
  };

  cmp-ctags = super.cmp-ctags.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-dap = super.cmp-dap.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.nvim-dap ];
  };

  cmp-dictionary = super.cmp-dictionary.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    nvimSkipModule = [
      # Test files
      "cmp_dictionary.dict.external_spec"
      "cmp_dictionary.dict.trie_spec"
      "cmp_dictionary.lib.trie_spec"
      "cmp_dictionary.lib.unknown_spec"
    ];
  };

  cmp-digraphs = super.cmp-digraphs.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-fish = super.cmp-fish.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-fuzzy-buffer = super.cmp-fuzzy-buffer.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.fuzzy-nvim ];
  };

  cmp-fuzzy-path = super.cmp-fuzzy-path.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.fuzzy-nvim ];
  };

  cmp-git = super.cmp-git.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = with self; [ plenary-nvim ];
  };

  cmp-greek = super.cmp-greek.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-look = super.cmp-look.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp_luasnip = super.cmp_luasnip.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.luasnip ];
  };

  cmp-neosnippet = super.cmp-neosnippet.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.neosnippet-vim ];
  };

  cmp-nixpkgs-maintainers = super.cmp-nixpkgs-maintainers.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-npm = super.cmp-npm.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.plenary-nvim ];
  };

  cmp-nvim-lsp-signature-help = super.cmp-nvim-lsp-signature-help.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-nvim-lua = super.cmp-nvim-lua.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-nvim-tags = super.cmp-nvim-tags.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-nvim-ultisnips = super.cmp-nvim-ultisnips.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-pandoc-nvim = super.cmp-pandoc-nvim.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.plenary-nvim ];
  };

  cmp-pandoc-references = super.cmp-pandoc-references.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-path = super.cmp-path.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-rg = super.cmp-rg.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-snippy = super.cmp-snippy.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.nvim-snippy ];
  };

  cmp-tabby = super.cmp-tabby.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-tabnine = super.cmp-tabnine.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    buildInputs = [ tabnine ];

    postFixup = ''
      mkdir -p $target/binaries/${tabnine.version}
      ln -s ${tabnine}/bin/ $target/binaries/${tabnine.version}/${tabnine.passthru.platform}
    '';
  };

  cmp-tmux = super.cmp-tmux.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ tmux ];
  };

  cmp-vim-lsp = super.cmp-vim-lsp.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.vim-lsp ];
  };

  cmp-vimwiki-tags = super.cmp-vimwiki-tags.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.vimwiki ];
  };

  cmp-vsnip = super.cmp-vsnip.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-vimtex = super.cmp-vimtex.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-zsh = super.cmp-zsh.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ zsh ];
  };

  cobalt2-nvim = super.cobalt2-nvim.overrideAttrs {
    dependencies = with self; [ colorbuddy-nvim ];
    # Few broken themes
    nvimSkipModule = [
      "cobalt2.plugins.init"
      "cobalt2.plugins.trouble"
      "cobalt2.plugins.gitsigns"
      "cobalt2.plugins.package-info"
      "cobalt2.plugins.indent-blankline"
      "cobalt2.plugins.marks"
      "cobalt2.theme"
    ];
  };

  coc-clangd = buildVimPlugin {
    inherit (coc-clangd) pname version meta;
    src = "${coc-clangd}/lib/node_modules/coc-clangd";
  };

  coc-css = buildVimPlugin {
    inherit (coc-css) pname version meta;
    src = "${coc-css}/lib/node_modules/coc-css";
  };

  coc-diagnostic = buildVimPlugin {
    inherit (coc-diagnostic) pname version meta;
    src = "${coc-diagnostic}/lib/node_modules/coc-diagnostic";
  };

  coc-pyright = buildVimPlugin {
    pname = "coc-pyright";
    inherit (coc-pyright) version meta;
    src = "${coc-pyright}/lib/node_modules/coc-pyright";
  };

  coc-nginx = buildVimPlugin {
    pname = "coc-nginx";
    inherit (nodePackages."@yaegassy/coc-nginx") version meta;
    src = "${nodePackages."@yaegassy/coc-nginx"}/lib/node_modules/@yaegassy/coc-nginx";
  };

  coc-toml = buildVimPlugin {
    pname = "coc-toml";
    inherit (coc-toml) version meta;
    src = "${coc-toml}/lib/node_modules/coc-toml";
  };

  codecompanion-nvim = super.codecompanion-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Optional provider dependencies
      "codecompanion.providers.diff.mini_diff"
      "codecompanion.providers.actions.telescope"
      "codecompanion.providers.actions.mini_pick"
      # Requires setup call
      "codecompanion.actions.static"
      "codecompanion.actions.init"
      # Test
      "minimal"
    ];
  };

  codeium-nvim =
    let
      # Update according to https://github.com/Exafunction/codeium.nvim/blob/main/lua/codeium/versions.json
      codeiumVersion = "1.20.9";
      codeiumHashes = {
        x86_64-linux = "sha256-IeNK7UQtOhqC/eQv7MAya4jB1WIGykSR7IgutZatmHM=";
        aarch64-linux = "sha256-ujTFki/3V79El2WCkG0PJhbaMT0knC9mrS9E7Uv9HD4=";
        x86_64-darwin = "sha256-r2KloEQsUku9sk8h76kwyQuMTHcq/vwfTSK2dkiXDzE=";
        aarch64-darwin = "sha256-1jNH0Up8mAahDgvPF6g42LV+RVDVsPqDM54lE2KYY48=";
      };

      codeium' = codeium.overrideAttrs rec {
        version = codeiumVersion;

        src =
          let
            inherit (stdenv.hostPlatform) system;
            throwSystem = throw "Unsupported system: ${system}";

            platform =
              {
                x86_64-linux = "linux_x64";
                aarch64-linux = "linux_arm";
                x86_64-darwin = "macos_x64";
                aarch64-darwin = "macos_arm";
              }
              .${system} or throwSystem;

            hash = codeiumHashes.${system} or throwSystem;
          in
          fetchurl {
            name = "codeium-${version}.gz";
            url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_${platform}.gz";
            inherit hash;
          };
      };

    in
    super.codeium-nvim.overrideAttrs {
      dependencies = [ self.plenary-nvim ];
      buildPhase = ''
        cat << EOF > lua/codeium/installation_defaults.lua
        return {
          tools = {
            language_server = "${codeium'}/bin/codeium_language_server"
          };
        };
        EOF
      '';

      doCheck = true;
      checkInputs = [
        jq
        codeium'
      ];
      checkPhase = ''
        runHook preCheck

        expected_codeium_version=$(jq -r '.version' lua/codeium/versions.json)
        actual_codeium_version=$(codeium_language_server --version)

        expected_codeium_stamp=$(jq -r '.stamp' lua/codeium/versions.json)
        actual_codeium_stamp=$(codeium_language_server --stamp | grep STABLE_BUILD_SCM_REVISION | cut -d' ' -f2)

        if [ "$actual_codeium_stamp" != "$expected_codeium_stamp" ]; then
          echo "
        The version of codeium patched in vimPlugins.codeium-nvim is incorrect.
        Expected stamp: $expected_codeium_stamp
        Actual stamp: $actual_codeium_stamp

        Expected codeium version: $expected_codeium_version
        Actual codeium version: $actual_codeium_version

        Please, update 'codeiumVersion' in pkgs/applications/editors/vim/plugins/overrides.nix accordingly to:
        https://github.com/Exafunction/codeium.nvim/blob/main/lua/codeium/versions.json
          "
          exit 1
        fi

        runHook postCheck
      '';
    };

  codesnap-nvim = callPackage ./non-generated/codesnap-nvim { };

  codewindow-nvim = super.codewindow-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  colorful-menu-nvim = super.colorful-menu-nvim.overrideAttrs {
    # Local bug reproduction modules
    nvimSkipModule = [
      "repro_blink"
      "repro_cmp"
    ];
  };

  command-t = super.command-t.overrideAttrs {
    nativeBuildInputs = [
      getconf
      ruby
    ];
    buildPhase = ''
      substituteInPlace lua/wincent/commandt/lib/Makefile \
        --replace-fail '/bin/bash' 'bash' \
        --replace-fail xcrun ""
      make build
      rm ruby/command-t/ext/command-t/*.o
    '';
  };

  competitest-nvim = super.competitest-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  compiler-explorer-nvim = super.compiler-explorer-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  compiler-nvim = super.compiler-nvim.overrideAttrs {
    dependencies = [ self.overseer-nvim ];
  };

  completion-buffers = super.completion-buffers.overrideAttrs {
    dependencies = [ self.completion-nvim ];
  };

  completion-tabnine = super.completion-tabnine.overrideAttrs {
    dependencies = [ self.completion-nvim ];
    buildInputs = [ tabnine ];
    postFixup = ''
      mkdir -p $target/binaries
      ln -s ${tabnine}/bin/TabNine $target/binaries/TabNine_$(uname -s)
    '';
  };

  completion-treesitter = super.completion-treesitter.overrideAttrs {
    dependencies = with self; [
      completion-nvim
      nvim-treesitter
    ];
  };

  conjure = super.conjure.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Test mismatch of directory because of nix generated path
      "conjure-spec.client.fennel.nfnl_spec"
    ];
  };

  context-vim = super.context-vim.overrideAttrs {
    # Vim plugin with optional lua highlight module
    nvimSkipModule = "context.highlight";
  };

  CopilotChat-nvim = super.CopilotChat-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional integrations
      fzf-lua
      telescope-nvim
      snacks-nvim
    ];
    dependencies = with self; [
      copilot-lua
      plenary-nvim
    ];
  };

  copilot-cmp = super.copilot-cmp.overrideAttrs {
    dependencies = [ self.copilot-lua ];
  };

  copilot-lualine = super.copilot-lualine.overrideAttrs {
    dependencies = with self; [
      copilot-lua
      lualine-nvim
    ];
    doInstallCheck = true;
  };

  copilot-vim = super.copilot-vim.overrideAttrs (old: {
    postInstall = ''
      substituteInPlace $out/autoload/copilot/client.vim \
        --replace-fail "  let node = get(g:, 'copilot_node_command', ''\'''\')" \
                  "  let node = get(g:, 'copilot_node_command', '${nodejs}/bin/node')"
    '';

    meta = old.meta // {
      license = lib.licenses.unfree;
    };
  });

  coq_nvim = super.coq_nvim.overrideAttrs {
    passthru.python3Dependencies =
      ps: with ps; [
        pynvim-pp
        pyyaml
        std2
      ];

    # We need some patches so it stops complaining about not being in a venv
    patches = [ ./patches/coq_nvim/emulate-venv.patch ];

    nvimRequireCheck = [
      # Other modules require global variables
      "coq"
    ];
  };

  cord-nvim = callPackage ./non-generated/cord-nvim { };

  cornelis = super.cornelis.overrideAttrs {
    dependencies = [ self.vim-textobj-user ];
    opt = [ self.vim-which-key ];
    # Unconditionally use the cornelis binary provided by the top-level package:
    patches = [ ./patches/cornelis/0001-Unconditionally-use-global-binary.patch ];
    postInstall = ''
      substituteInPlace $out/ftplugin/agda.vim \
        --subst-var-by CORNELIS "${lib.getBin cornelis}/bin/cornelis"
    '';
  };

  cpsm = super.cpsm.overrideAttrs {
    nativeBuildInputs = [ cmake ];
    buildInputs = [
      python3
      boost
      icu
      ncurses
    ];
    buildPhase = ''
      patchShebangs .
      export PY3=ON
      ./install.sh
    '';
  };

  crates-nvim = super.crates-nvim.overrideAttrs {
    checkInputs = [
      # Optional null-ls integration
      self.none-ls-nvim
    ];
    dependencies = [ self.plenary-nvim ];
  };

  cspell-nvim = super.cspell-nvim.overrideAttrs {
    dependencies = with self; [
      none-ls-nvim
      plenary-nvim
    ];
  };

  ctrlp-cmatcher = super.ctrlp-cmatcher.overrideAttrs {
    # drop Python 2 patches
    # https://github.com/JazzCore/ctrlp-cmatcher/pull/44
    patches = [
      (fetchpatch {
        name = "drop_python2_pt1.patch";
        url = "https://github.com/JazzCore/ctrlp-cmatcher/commit/3abad6ea155a7f6e138e1de3ac5428177bfb0254.patch";
        sha256 = "sha256-fn2puqYeJdPTdlTT4JjwVz7b3A+Xcuj/xtP6TETlB1U=";
      })
      (fetchpatch {
        name = "drop_python2_pt2.patch";
        url = "https://github.com/JazzCore/ctrlp-cmatcher/commit/385c8d02398dbb328b1a943a94e7109fe6473a08.patch";
        sha256 = "sha256-yXKCq8sqO0Db/sZREuSeqKwKO71cmTsAvWftoOQehZo=";
      })
    ];
    buildInputs = with python3.pkgs; [
      python3
      setuptools
    ];
    buildPhase = ''
      patchShebangs .
      ./install.sh
    '';
  };

  darkearth-nvim = super.darkearth-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
    # Lua module used to build theme
    nvimSkipModule = "shipwright_build";
  };

  ddc-filter-matcher_head = super.ddc-filter-matcher_head.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-source-lsp = super.ddc-source-lsp.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-vim = super.ddc-vim.overrideAttrs {
    dependencies = [ self.denops-vim ];
  };

  ddc-filter-sorter_rank = super.ddc-filter-sorter_rank.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-ui-native = super.ddc-ui-native.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-ui-pum = super.ddc-ui-pum.overrideAttrs {
    dependencies = with self; [
      ddc-vim
      pum-vim
    ];
  };

  ddc-source-around = super.ddc-source-around.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-source-file = super.ddc-source-file.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-fuzzy = super.ddc-fuzzy.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  defx-nvim = super.defx-nvim.overrideAttrs {
    dependencies = [ self.nvim-yarp ];
  };

  denops-vim = super.denops-vim.overrideAttrs {
    postPatch = ''
      # Use Nix's Deno instead of an arbitrary install
      substituteInPlace ./autoload/denops.vim --replace-fail "call denops#_internal#conf#define('denops#deno', 'deno')" "call denops#_internal#conf#define('denops#deno', '${deno}/bin/deno')"
    '';
  };

  deoplete-fish = super.deoplete-fish.overrideAttrs {
    dependencies = with self; [
      deoplete-nvim
      vim-fish
    ];
  };

  deoplete-go = super.deoplete-go.overrideAttrs {
    nativeBuildInputs = [ (python3.withPackages (ps: with ps; [ setuptools ])) ];
    buildPhase = ''
      pushd ./rplugin/python3/deoplete/ujson
      python3 setup.py build --build-base=$PWD/build --build-lib=$PWD/build
      popd
      find ./rplugin/ -name "ujson*.so" -exec mv -v {} ./rplugin/python3/ \;
    '';
  };

  deoplete-khard = super.deoplete-khard.overrideAttrs {
    dependencies = [ self.deoplete-nvim ];
    passthru.python3Dependencies = ps: [ (ps.toPythonModule khard) ];
    meta = {
      description = "Address-completion for khard via deoplete";
      homepage = "https://github.com/nicoe/deoplete-khard";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ jorsn ];
    };
  };

  diagram-nvim = super.diagram-nvim.overrideAttrs {
    dependencies = [ self.image-nvim ];
  };

  diffview-nvim = super.diffview-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];

    nvimSkipModule = [
      # https://github.com/sindrets/diffview.nvim/issues/498
      "diffview.api.views.diff.diff_view"
      "diffview.scene.layouts.diff_2"
      "diffview.scene.layouts.diff_2_hor"
      "diffview.scene.layouts.diff_2_ver"
      "diffview.scene.layouts.diff_3"
      "diffview.scene.layouts.diff_3_hor"
      "diffview.scene.layouts.diff_3_mixed"
      "diffview.scene.layouts.diff_3_ver"
      "diffview.scene.layouts.diff_4"
      "diffview.scene.layouts.diff_4_mixed"
      "diffview.scene.views.diff.diff_view"
      "diffview.scene.views.file_history.file_history_panel"
      "diffview.scene.views.file_history.option_panel"
      "diffview.scene.window"
      "diffview.ui.panels.commit_log_panel"
      "diffview.ui.panels.help_panel"
      "diffview.ui.panel"
      "diffview.vcs.adapters.git.init"
      "diffview.vcs.adapters.hg.init"
      "diffview.vcs.adapter"
      "diffview.vcs.init"
      "diffview.vcs.utils"
      "diffview.job"
      "diffview.lib"
      "diffview.multi_job"
    ];

    doInstallCheck = true;
  };

  direnv-vim = super.direnv-vim.overrideAttrs (old: {
    preFixup =
      old.preFixup or ""
      + ''
        substituteInPlace $out/autoload/direnv.vim \
          --replace-fail "let s:direnv_cmd = get(g:, 'direnv_cmd', 'direnv')" \
            "let s:direnv_cmd = get(g:, 'direnv_cmd', '${lib.getBin direnv}/bin/direnv')"
      '';
  });

  dotnet-nvim = super.dotnet-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      plenary-nvim
    ];
  };

  dropbar-nvim = super.dropbar-nvim.overrideAttrs {
    # Requires global config table
    nvimSkipModule = "dropbar.menu";
  };

  easy-dotnet-nvim = super.easy-dotnet-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
    checkInputs = with self; [
      # Pickers, can use telescope or fzf-lua
      fzf-lua
    ];
  };

  efmls-configs-nvim = super.efmls-configs-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  elixir-tools-nvim = super.elixir-tools-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    fixupPhase = ''
      patchShebangs $(find $out/bin/ -type f -not -name credo-language-server)
    '';
  };

  executor-nvim = super.executor-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  faust-nvim = super.faust-nvim.overrideAttrs {
    dependencies = with self; [
      luasnip
      nvim-fzf
    ];
    nvimSkipModule = [
      # E5108: Error executing lua vim/_init_packages.lua:0: ...in-faust-nvim-2022-06-01/lua/faust-nvim/autosnippets.lua:3: '=' expected near 'wd'
      "faust-nvim.autosnippets"
    ];
  };

  fcitx-vim = super.fcitx-vim.overrideAttrs {
    passthru.python3Dependencies = ps: with ps; [ dbus-python ];
    meta = {
      description = "Keep and restore fcitx state when leaving/re-entering insert mode or search mode";
      license = lib.licenses.mit;
    };
  };

  flash-nvim = super.flash-nvim.overrideAttrs {
    # Docs require lazyvim
    # dependencies = with self; [ lazy-nvim ];
    nvimSkipModule = "flash.docs";
  };

  flit-nvim = super.flit-nvim.overrideAttrs {
    dependencies = [ self.leap-nvim ];
  };

  flutter-tools-nvim = super.flutter-tools-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    # Optional nvim-dap module
    nvimSkipModule = "flutter-tools.dap";
  };

  follow-md-links-nvim = super.follow-md-links-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  forms = super.forms.overrideAttrs {
    dependencies = [ self.self ];
  };

  fruzzy =
    let
      # until https://github.com/NixOS/nixpkgs/pull/67878 is merged, there's no better way to install nim libraries with nix
      nimpy = fetchFromGitHub {
        owner = "yglukhov";
        repo = "nimpy";
        rev = "4840d1e438985af759ddf0923e7a9250fd8ea0da";
        sha256 = "0qqklvaajjqnlqm3rkk36pwwnn7x942mbca7nf2cvryh36yg4q5k";
      };
      binaryheap = fetchFromGitHub {
        owner = "bluenote10";
        repo = "nim-heap";
        rev = "c38039309cb11391112571aa332df9c55f625b54";
        sha256 = "05xdy13vm5n8dw2i366ppbznc4cfhq23rdcklisbaklz2jhdx352";
      };
    in
    super.fruzzy.overrideAttrs (old: {
      buildInputs = [ nim1 ];
      patches = [
        (replaceVars ./patches/fruzzy/get_version.patch {
          inherit (old) version;
        })
      ];
      configurePhase = ''
        substituteInPlace Makefile \
          --replace-fail \
            "nim c" \
            "nim c --nimcache:$TMP --path:${nimpy} --path:${binaryheap}"
      '';
      buildPhase = ''
        make build
      '';
    });

  fuzzy-nvim = super.fuzzy-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional sorters
      telescope-zf-native-nvim
    ];
    dependencies = [ self.telescope-fzf-native-nvim ];
    nvimSkipModule = [
      # TODO: package fzy-lua-native
      "fuzzy_nvim.fzy_matcher"
    ];
  };

  fugit2-nvim = super.fugit2-nvim.overrideAttrs {
    # Requires web-devicons but mini.icons can mock them up
    checkInputs = [
      self.nvim-web-devicons
    ];
    dependencies = with self; [
      nui-nvim
      plenary-nvim
    ];
    # Patch libgit2 library dependency
    postPatch = ''
      substituteInPlace lua/fugit2/libgit2.lua \
        --replace-fail \
        'M.library_path = "libgit2"' \
        'M.library_path = "${lib.getLib libgit2}/lib/libgit2${stdenv.hostPlatform.extensions.sharedLibrary}"'
    '';
  };

  fzf-checkout-vim = super.fzf-checkout-vim.overrideAttrs {
    # The plugin has a makefile which tries to run tests in a docker container.
    # This prevents it.
    prePatch = ''
      rm Makefile
    '';
  };

  fzf-hoogle-vim = super.fzf-hoogle-vim.overrideAttrs (oa: {
    # add this to your lua config to prevent the plugin from trying to write in the
    # nix store:
    # vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json'
    propagatedBuildInputs = [
      jq
      gawk
    ];
    dependencies = [ self.fzf-vim ];
    passthru = oa.passthru // {

      initLua = "vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json";
    };
  });

  fzf-lsp-nvim = super.fzf-lsp-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  fzf-lua = neovimUtils.buildNeovimPlugin {
    luaAttr = luaPackages.fzf-lua;
    runtimeDeps = [ fzf ];
  };

  fzf-vim = super.fzf-vim.overrideAttrs {
    dependencies = [ self.fzfWrapper ];
  };

  # Mainly used as a dependency for fzf-vim. Wraps the fzf program as a vim
  # plugin, since part of the fzf vim plugin is included in the main fzf
  # program.
  fzfWrapper = buildVimPlugin {
    inherit (fzf) src version;
    pname = "fzf";
    postInstall = ''
      ln -s ${fzf}/bin/fzf $target/bin/fzf
    '';
  };

  ghcid = super.ghcid.overrideAttrs {
    configurePhase = "cd plugins/nvim";
  };

  gitlab-vim = callPackage ./non-generated/gitlab-vim { };

  gitlinker-nvim = super.gitlinker-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  gitsigns-nvim = super.gitsigns-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  git-worktree-nvim = super.git-worktree-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  go-nvim = super.go-nvim.overrideAttrs {
    nvimSkipModule = [
      # Null-ls
      "go.null_ls"
      # _GO_NVIM_CFG
      "go.inlay"
      "go.project"
      "go.comment"
      "go.tags"
      "go.gotests"
      "go.format"
      # nvim-treesitter
      "go.gotest"
      "go.ginkgo"
      "go.ts.go"
      "go.ts.utils"
      "go.ts.nodes"
      "go.fixplurals"
      # Luasnip
      "go.snips"
      "snips.all"
      "snips.go"
    ];
  };

  guard-collection = super.guard-collection.overrideAttrs {
    dependencies = [ self.guard-nvim ];
  };

  gx-nvim = super.gx-nvim.overrideAttrs {
    patches = lib.optionals stdenv.hostPlatform.isLinux [
      (replaceVars ./patches/gx-nvim/fix-paths.patch {
        inherit xdg-utils;
      })
    ];

    nvimRequireCheck = "gx";
  };

  hardhat-nvim = super.hardhat-nvim.overrideAttrs {
    checkInputs = with self; [
      # optional integrations
      neotest
      telescope-nvim
      overseer-nvim
    ];

    dependencies = with self; [
      plenary-nvim
    ];

    nvimSkipModule = [
      # Cannot find hardhat.extmarks
      "overseer.component.hardhat.refresh_gas_extmarks"
    ];
  };

  hare-vim = callPackage ./non-generated/hare-vim { };

  harpoon = super.harpoon.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  harpoon2 = super.harpoon2.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Access harpoon data file
      "harpoon.scratch.toggle"
    ];
  };

  haskell-snippets-nvim = super.haskell-snippets-nvim.overrideAttrs {
    dependencies = [ self.luasnip ];
  };

  haskell-scope-highlighting-nvim = super.haskell-scope-highlighting-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  haskell-tools-nvim = neovimUtils.buildNeovimPlugin {
    luaAttr = luaPackages.haskell-tools-nvim;
    nvimSkipModule = [
      # Optional telescope integration
      "haskell-tools.hoogle.helpers"
    ];
  };

  helpview-nvim = super.helpview-nvim.overrideAttrs {
    nvimSkipModule = "definitions.__vimdoc";
  };

  hex-nvim = super.hex-nvim.overrideAttrs {
    runtimeDeps = [ xxd ];
  };

  himalaya-vim = super.himalaya-vim.overrideAttrs {
    buildInputs = [ himalaya ];
    # vim plugin with optional telescope lua module
    nvimSkipModule = [
      "himalaya.folder.pickers.fzflua"
      "himalaya.folder.pickers.telescope"
    ];
  };

  hover-nvim = super.hover-nvim.overrideAttrs {
    # Single provider issue with reading from config
    # /lua/hover/providers/fold_preview.lua:27: attempt to index local 'config' (a nil value)
    nvimSkipModule = "hover.providers.fold_preview";
  };

  hunk-nvim = super.hunk-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  # https://hurl.dev/
  hurl = buildVimPlugin {
    pname = "hurl";
    version = hurl.version;
    # dontUnpack = true;

    src = "${hurl.src}/contrib/vim";
  };

  idris2-nvim = super.idris2-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      nvim-lspconfig
    ];

    doInstallCheck = true;
  };

  image-nvim = super.image-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      nvim-treesitter-parsers.markdown_inline
      nvim-treesitter-parsers.norg
    ];

    # Add magick to package.path
    patches = [ ./patches/image-nvim/magick.patch ];

    postPatch = ''
      substituteInPlace lua/image/magick.lua \
        --replace-fail @nix_magick@ ${luajitPackages.magick}
    '';

  };

  indent-blankline-nvim = super.indent-blankline-nvim.overrideAttrs {
    # Meta file
    nvimSkipModule = "ibl.config.types";
  };

  instant-nvim = super.instant-nvim.overrideAttrs {
    nvimSkipModule = [
      # Requires global variable config
      "instant"
      # instant/log.lua:12: cannot use '...' outside a vararg function near '...'
      "instant.log"
    ];
  };

  intellitab-nvim = super.intellitab-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  jedi-vim = super.jedi-vim.overrideAttrs {
    # checking for python3 support in vim would be neat, too, but nobody else seems to care
    buildInputs = [ python3.pkgs.jedi ];
    meta = {
      description = "code-completion for python using python-jedi";
      license = lib.licenses.mit;
    };
  };

  jellybeans-nvim = super.jellybeans-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
  };

  jupytext-nvim = super.jupytext-nvim.overrideAttrs {
    passthru.python3Dependencies = ps: [ ps.jupytext ];
  };

  kulala-nvim = super.kulala-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      nvim-treesitter-parsers.http
    ];
    buildInputs = [ curl ];
    postPatch = ''
      substituteInPlace lua/kulala/config/init.lua \
        --replace-fail 'curl_path = "curl"' 'curl_path = "${lib.getExe curl}"'
    '';
  };

  LanguageClient-neovim = callPackage ./non-generated/LanguageClient-neovim { };

  LazyVim = super.LazyVim.overrideAttrs {
    # Any other dependency is optional
    dependencies = [ self.lazy-nvim ];
    nvimSkipModule = [
      # attempt to index global 'LazyVim' (a nil value)
      "lazyvim.config.keymaps"
      "lazyvim.plugins.extras.ai.tabnine"
      "lazyvim.plugins.extras.coding.blink"
      "lazyvim.plugins.extras.coding.luasnip"
      "lazyvim.plugins.extras.coding.neogen"
      "lazyvim.plugins.extras.editor.fzf"
      "lazyvim.plugins.extras.editor.snacks_picker"
      "lazyvim.plugins.extras.editor.telescope"
      "lazyvim.plugins.extras.formatting.prettier"
      "lazyvim.plugins.extras.lang.markdown"
      "lazyvim.plugins.extras.lang.omnisharp"
      "lazyvim.plugins.extras.lang.python"
      "lazyvim.plugins.extras.lang.svelte"
      "lazyvim.plugins.extras.lang.typescript"
      "lazyvim.plugins.init"
      "lazyvim.plugins.ui"
      "lazyvim.plugins.xtras"
    ];
  };

  lazy-lsp-nvim = super.lazy-lsp-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  lazy-nvim = super.lazy-nvim.overrideAttrs {
    patches = [ ./patches/lazy-nvim/no-helptags.patch ];
    nvimSkipModule = [
      # Requires headless config option
      "lazy.manage.task.init"
      "lazy.manage.checker"
      "lazy.manage.init"
      "lazy.manage.runner"
      "lazy.view.commands"
      "lazy.build"
    ];
  };

  lean-nvim = super.lean-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-lspconfig
      plenary-nvim
    ];
  };

  LeaderF = super.LeaderF.overrideAttrs {
    nativeBuildInputs = [ python3.pkgs.setuptools ];
    buildInputs = [ python3 ];
    # rm */build/ to prevent dependencies on gcc
    # strip the *.so to keep files small
    buildPhase = ''
      patchShebangs .
      ./install.sh
      rm autoload/leaderf/fuzzyMatch_C/build/ -r
    '';
    stripDebugList = [ "autoload/leaderf/python" ];
  };

  leap-ast-nvim = super.leap-ast-nvim.overrideAttrs {
    dependencies = with self; [
      leap-nvim
      nvim-treesitter
    ];
  };

  leetcode-nvim = super.leetcode-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      plenary-nvim
      telescope-nvim
    ];

    doInstallCheck = true;
    nvimSkipModule = [
      # Requires setup call
      "leetcode.api.auth"
      "leetcode.api.headers"
      "leetcode.api.interpreter"
      "leetcode.api.problems"
      "leetcode.api.question"
      "leetcode.api.statistics"
      "leetcode.api.utils"
      "leetcode.cache.cookie"
      "leetcode.cache.init"
      "leetcode.cache.problemlist"
      "leetcode.picker.language.fzf"
      "leetcode.picker.question.fzf"
      "leetcode.picker.question.init"
      "leetcode.picker.question.telescope"
      "leetcode.picker.tabs.fzf"
      "leetcode.runner.init"
      "leetcode-plugins.cn.api"
      "leetcode-ui.group.page.stats"
      "leetcode-ui.group.similar-questions"
      "leetcode-ui.layout.console"
      "leetcode-ui.lines.calendar"
      "leetcode-ui.lines.solved"
      "leetcode-ui.popup.console.result"
      "leetcode-ui.popup.info"
      "leetcode-ui.popup.languages"
      "leetcode-ui.popup.skills"
      "leetcode-ui.question"
      "leetcode-ui.renderer.menu"
      "leetcode-ui.renderer.result"
    ];
  };

  legendary-nvim = super.legendary-nvim.overrideAttrs {
    dependencies = [ self.sqlite-lua ];
    nvimSkipModule = [
      "vimdoc-gen"
      "vimdocrc"
    ];
  };

  lens-vim = super.lens-vim.overrideAttrs {
    # remove duplicate g:lens#animate in doc/lens.txt
    # https://github.com/NixOS/nixpkgs/pull/105810#issuecomment-740007985
    # https://github.com/camspiers/lens.vim/pull/40/files
    patches = [
      ./patches/lens-vim/remove_duplicate_g_lens_animate.patch
    ];
  };

  lf-vim = super.lf-vim.overrideAttrs {
    dependencies = [ self.vim-floaterm ];
  };

  lightline-bufferline = super.lightline-bufferline.overrideAttrs {
    # Requires web-devicons but mini.icons can mock them up
    checkInputs = [ self.nvim-web-devicons ];
  };

  lir-nvim = super.lir-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  lispdocs-nvim = super.lispdocs-nvim.overrideAttrs {
    dependencies = with self; [
      conjure
      sqlite-lua
      telescope-nvim
      plenary-nvim
    ];
    nvimSkipModule = [
      # Attempt to connect to sqlitedb
      "lispdocs.db"
      "lispdocs.finder"
      "lispdocs"
    ];
  };

  litee-calltree-nvim = super.litee-calltree-nvim.overrideAttrs {
    dependencies = [ self.litee-nvim ];
  };

  litee-filetree-nvim = super.litee-filetree-nvim.overrideAttrs {
    dependencies = [ self.litee-nvim ];
  };

  litee-symboltree-nvim = super.litee-symboltree-nvim.overrideAttrs {
    dependencies = [ self.litee-nvim ];
  };

  lspcontainers-nvim = super.lspcontainers-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  lsp_extensions-nvim = super.lsp_extensions-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  lsp_lines-nvim = callPackage ./non-generated/lsp_lines-nvim { };

  lspecho-nvim = super.lspecho-nvim.overrideAttrs {
    meta.license = lib.licenses.mit;
  };

  lspsaga-nvim = super.lspsaga-nvim.overrideAttrs {
    # Other modules require setup call first
    nvimRequireCheck = "lspsaga";
  };

  ltex_extra-nvim = super.ltex_extra-nvim.overrideAttrs {
    # Other modules require setup call first
    nvimRequireCheck = "ltex_extra";
  };

  lualine-lsp-progress = super.lualine-lsp-progress.overrideAttrs {
    dependencies = [ self.lualine-nvim ];
  };

  luasnip = super.luasnip.overrideAttrs {
    dependencies = [ luaPackages.jsregexp ];
  };

  luasnip-latex-snippets-nvim = super.luasnip-latex-snippets-nvim.overrideAttrs {
    dependencies = [ self.luasnip ];
    # E5108: /luasnip-latex-snippets/luasnippets/tex/utils/init.lua:3: module 'luasnip-latex-snippets.luasnippets.utils.conditions' not found:
    # Need to fix upstream
    nvimSkipModule = [
      "luasnip-latex-snippets.luasnippets.tex.utils.init"
    ];
  };

  LuaSnip-snippets-nvim = super.LuaSnip-snippets-nvim.overrideAttrs {
    checkInputs = [ self.luasnip ];
  };

  magma-nvim = super.magma-nvim.overrideAttrs {
    passthru.python3Dependencies =
      ps: with ps; [
        pynvim
        jupyter-client
        ueberzug
        pillow
        cairosvg
        plotly
        ipykernel
        pyperclip
        pnglatex
      ];
  };

  markdown-preview-nvim =
    let
      # We only need its dependencies `node-modules`.
      nodeDep = mkYarnModules rec {
        inherit (super.markdown-preview-nvim) pname version;
        packageJSON = ./markdown-preview-nvim/package.json;
        yarnLock = "${super.markdown-preview-nvim.src}/yarn.lock";
        offlineCache = fetchYarnDeps {
          inherit yarnLock;
          hash = "sha256-kzc9jm6d9PJ07yiWfIOwqxOTAAydTpaLXVK6sEWM8gg=";
        };
      };
    in
    super.markdown-preview-nvim.overrideAttrs {
      patches = [
        (replaceVars ./markdown-preview-nvim/fix-node-paths.patch {
          node = "${nodejs}/bin/node";
        })
      ];
      postInstall = ''
        ln -s ${nodeDep}/node_modules $out/app
      '';

      nativeBuildInputs = [ nodejs ];
      doInstallCheck = true;
      installCheckPhase = ''
        node $out/app/index.js --version
      '';
    };

  markid = super.markid.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  mason-lspconfig-nvim = super.mason-lspconfig-nvim.overrideAttrs {
    dependencies = with self; [
      mason-nvim
      nvim-lspconfig
    ];
  };

  mason-null-ls-nvim = super.mason-null-ls-nvim.overrideAttrs {
    dependencies = with self; [
      mason-nvim
      null-ls-nvim
    ];
  };

  mason-nvim-dap-nvim = super.mason-nvim-dap-nvim.overrideAttrs {
    dependencies = with self; [
      mason-nvim
      nvim-dap
    ];
  };

  mason-nvim = super.mason-nvim.overrideAttrs {
    # lua/mason-vendor/zzlib/inflate-bwo.lua:15: 'end' expected near '&'
    nvimSkipModule = "mason-vendor.zzlib.inflate-bwo";
  };

  mason-tool-installer-nvim = super.mason-tool-installer-nvim.overrideAttrs {
    dependencies = [ self.mason-nvim ];
  };

  material-vim = super.material-vim.overrideAttrs {
    # vim plugin with optional lualine module
    nvimSkipModule = "material.lualine";
  };

  meson = buildVimPlugin {
    inherit (meson) pname version src;
    preInstall = "cd data/syntax-highlighting/vim";
    meta.maintainers = with lib.maintainers; [ vcunat ];
  };

  mind-nvim = super.mind-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  mini-nvim = super.mini-nvim.overrideAttrs {
    # reduce closure size
    postInstall = ''
      rm -rf $out/{Makefile,benchmarks,readmes,tests,scripts}
    '';
  };

  git-conflict-nvim = super.git-conflict-nvim.overrideAttrs {
    # TODO: Remove after next fixed version
    # https://github.com/akinsho/git-conflict.nvim/issues/103
    version = "2.1.0";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "git-conflict.nvim";
      tag = "v2.1.0";
      hash = "sha256-1t0kKxTGLuOvuRkoLgkoqMZpF+oKo8+gMsTdgPsSb+8=";
    };
  };

  minimap-vim = super.minimap-vim.overrideAttrs {
    preFixup = ''
      substituteInPlace $out/plugin/minimap.vim \
        --replace-fail "code-minimap" "${code-minimap}/bin/code-minimap"
      substituteInPlace $out/bin/minimap_generator.sh \
        --replace-fail "code-minimap" "${code-minimap}/bin/code-minimap"
    '';

    doInstallCheck = true;
    vimCommandCheck = "MinimapToggle";
  };

  minsnip-nvim = buildVimPlugin {
    pname = "minsnip.nvim";
    version = "2022-01-04";
    src = fetchFromGitHub {
      owner = "jose-elias-alvarez";
      repo = "minsnip.nvim";
      rev = "6ae2f3247b3a2acde540ccef2e843fdfcdfebcee";
      sha256 = "1db5az5civ2bnqg7v3g937mn150ys52258c3glpvdvyyasxb4iih";
    };
    meta.homepage = "https://github.com/jose-elias-alvarez/minsnip.nvim/";
  };

  minuet-ai-nvim = super.minuet-ai-nvim.overrideAttrs {
    checkInputs = [
      # optional cmp integration
      self.nvim-cmp
    ];
    dependencies = with self; [ plenary-nvim ];
    nvimSkipModule = [
      # Backends require configuration
      "minuet.backends.claude"
      "minuet.backends.codestral"
      "minuet.backends.gemini"
      "minuet.backends.huggingface"
      "minuet.backends.openai"
      "minuet.backends.openai_compatible"
      "minuet.backends.openai_fim_compatible"
    ];
  };

  mkdnflow-nvim = super.mkdnflow-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    # Requires setup call and has optional nvim-cmp dependency
    nvimRequireCheck = "mkdnflow";
  };

  modicator-nvim = super.modicator-nvim.overrideAttrs {
    # Optional lualine integration
    nvimSkipModule = "modicator.integration.lualine.init";
  };

  molten-nvim = super.molten-nvim.overrideAttrs {
    nvimSkipModule = [
      # Optional image providers
      "load_image_nvim"
      "load_wezterm_nvim"
    ];
  };

  moveline-nvim = callPackage ./non-generated/moveline-nvim { };

  multicursors-nvim = super.multicursors-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      hydra-nvim
    ];
  };

  muren-nvim = super.muren-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  ncm2 = super.ncm2.overrideAttrs {
    dependencies = [ self.nvim-yarp ];
  };

  ncm2-jedi = super.ncm2-jedi.overrideAttrs {
    dependencies = with self; [
      nvim-yarp
      ncm2
    ];
    passthru.python3Dependencies = ps: with ps; [ jedi ];
  };

  ncm2-neoinclude = super.ncm2-neoinclude.overrideAttrs {
    dependencies = [ self.neoinclude-vim ];
  };

  ncm2-neosnippet = super.ncm2-neosnippet.overrideAttrs {
    dependencies = [ self.neosnippet-vim ];
  };

  ncm2-syntax = super.ncm2-syntax.overrideAttrs {
    dependencies = [ self.neco-syntax ];
  };

  ncm2-ultisnips = super.ncm2-ultisnips.overrideAttrs {
    dependencies = [ self.ultisnips ];
  };

  neoconf-nvim = super.neoconf-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];

    doInstallCheck = true;
  };

  neogit = super.neogit.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Optional diffview integration
      "neogit.integrations.diffview"
      "neogit.popups.diff.actions"
      "neogit.popups.diff.init"
    ];
  };

  neorepl-nvim = super.neorepl-nvim.overrideAttrs {
    nvimSkipModule = [
      # Requires main module loaded first
      "neorepl.bufs"
      "neorepl.map"
      "neorepl.repl"
    ];
  };

  neorg-telescope = super.neorg-telescope.overrideAttrs {
    buildInputs = [ luaPackages.lua-utils-nvim ];
    dependencies = with self; [
      neorg
      plenary-nvim
      telescope-nvim
    ];
  };

  neotest = super.neotest.overrideAttrs {
    dependencies = with self; [
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-bash = super.neotest-bash.overrideAttrs {
    dependencies = with self; [
      neotest
      plenary-nvim
    ];
  };

  neotest-dart = super.neotest-dart.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-deno = super.neotest-deno.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-dotnet = super.neotest-dotnet.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-elixir = super.neotest-elixir.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-foundry = super.neotest-foundry.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-go = super.neotest-go.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-golang = super.neotest-golang.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      nvim-dap-go
      nvim-treesitter
      plenary-nvim
    ];
  };

  neotest-gradle = super.neotest-gradle.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-gtest = super.neotest-gtest.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
      nvim-treesitter-parsers.cpp
    ];
    nvimSkipModule = [
      # lua/plenary/path.lua:511: FileNotFoundError from mkdir because of stdpath parent path missing
      "neotest-gtest.executables.global_registry"
      "neotest-gtest.executables.init"
      "neotest-gtest.executables.registry"
      "neotest-gtest.executables.ui"
      "neotest-gtest"
      "neotest-gtest.neotest_adapter"
      "neotest-gtest.report"
      "neotest-gtest.storage"
      "neotest-gtest.utils"
    ];
  };

  neotest-haskell = super.neotest-haskell.overrideAttrs {
    dependencies = with self; [
      neotest
      plenary-nvim
    ];
  };

  neotest-java = super.neotest-java.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-jest = super.neotest-jest.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
    ];
    # Unit test assert
    nvimSkipModule = "neotest-jest-assertions";
  };

  neotest-minitest = super.neotest-minitest.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-pest = super.neotest-pest.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-phpunit = super.neotest-phpunit.overrideAttrs {
    dependencies = with self; [
      neotest
      plenary-nvim
      nvim-nio
    ];
  };

  neotest-playwright = super.neotest-playwright.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
      telescope-nvim
    ];
    # Unit test assert
    nvimSkipModule = "neotest-playwright-assertions";
  };

  neotest-plenary = super.neotest-plenary.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-python = super.neotest-python.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-rspec = super.neotest-rspec.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-rust = super.neotest-rust.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-scala = super.neotest-scala.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-testthat = super.neotest-testthat.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neotest-vitest = super.neotest-vitest.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
    # Unit test assert
    nvimSkipModule = "neotest-vitest-assertions";
  };

  neotest-zig = super.neotest-zig.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };

  neo-tree-nvim = super.neo-tree-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      nui-nvim
    ];
  };

  netman-nvim = super.netman-nvim.overrideAttrs {
    nvimSkipModule = [
      # Optional neo-tree integration
      "netman.ui.neo-tree.init"
      "netman.ui.neo-tree.commands"
      "netman.ui.neo-tree.components"
    ];
  };

  neuron-nvim = super.neuron-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  nlsp-settings-nvim = super.nlsp-settings-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  noctis-nvim = super.noctis-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
  };

  noice-nvim = super.noice-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  none-ls-nvim = super.none-ls-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  notmuch-vim = notmuch.vim;

  NotebookNavigator-nvim = super.NotebookNavigator-nvim.overrideAttrs {
  };

  nterm-nvim = super.nterm-nvim.overrideAttrs {
    dependencies = [ self.aniseed ];
  };

  null-ls-nvim = super.null-ls-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  nvchad = super.nvchad.overrideAttrs {
    # You've signed up for a distro, providing dependencies.
    dependencies = with self; [
      gitsigns-nvim
      luasnip
      mason-nvim
      nvim-cmp
      nvim-lspconfig
      telescope-nvim
      nvim-treesitter
    ];
    nvimSkipModule = [
      # Requires global config setup
      "nvchad.configs.cmp"
      "nvchad.configs.gitsigns"
      "nvchad.configs.luasnip"
      "nvchad.configs.mason"
      "nvchad.configs.nvimtree"
      "nvchad.configs.telescope"
    ];
  };

  nvchad-ui = super.nvchad-ui.overrideAttrs {
    dependencies = [ self.nvzone-volt ];
    nvimSkipModule = [
      # Requires global config setup
      "nvchad.tabufline.modules"
      "nvchad.term.init"
      "nvchad.themes.init"
      "nvchad.themes.mappings"
      "nvchad.cheatsheet.grid"
      "nvchad.cheatsheet.simple"
    ];
  };

  nvim-autopairs = super.nvim-autopairs.overrideAttrs {
    nvimSkipModule = [
      # Optional completion dependencies
      "nvim-autopairs.completion.cmp"
      "nvim-autopairs.completion.compe"
    ];
  };

  nvim-biscuits = super.nvim-biscuits.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      plenary-nvim
    ];
  };

  nvim-cokeline = super.nvim-cokeline.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  nvim-dap-cortex-debug = super.nvim-dap-cortex-debug.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dbee = callPackage ./non-generated/nvim-dbee { };

  nvim-coverage = super.nvim-coverage.overrideAttrs {
    dependencies = with self; [
      neotest
      plenary-nvim
    ];
    nvimSkipModule = [
      # TODO: Add lua-xmlreader package
      "coverage.parsers.corbertura"
    ];
  };

  nvim-dap-lldb = super.nvim-dap-lldb.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dap-python = super.nvim-dap-python.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dap-rego = super.nvim-dap-rego.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dap-rr = super.nvim-dap-rr.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dap-ui = super.nvim-dap-ui.overrideAttrs {
    dependencies = with self; [
      nvim-dap
      nvim-nio
    ];

    doInstallCheck = true;
  };

  nvim-dap-virtual-text = super.nvim-dap-virtual-text.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-fzf-commands = super.nvim-fzf-commands.overrideAttrs {
    dependencies = [ self.nvim-fzf ];
    # Requires global variable setup nvim_fzf_directory
    nvimSkipModule = "fzf-commands.rg";
  };

  nvim-FeMaco-lua = super.nvim-FeMaco-lua.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-genghis = super.nvim-genghis.overrideAttrs {
    dependencies = [ self.dressing-nvim ];

    doInstallCheck = true;
  };

  nvim-gps = super.nvim-gps.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-java = super.nvim-java.overrideAttrs {
    dependencies = with self; [
      lua-async
      mason-nvim
      nui-nvim
      nvim-dap
      nvim-java-core
      nvim-java-dap
      nvim-java-refactor
      nvim-java-test
      nvim-lspconfig
    ];
  };

  nvim-java-core = super.nvim-java-core.overrideAttrs {
    dependencies = with self; [
      mason-nvim
      nvim-lspconfig
    ];
  };

  nvim-java-dap = super.nvim-java-dap.overrideAttrs {
    dependencies = [ self.nvim-java-core ];
  };

  nvim-java-refactor = super.nvim-java-refactor.overrideAttrs {
    dependencies = [ self.nvim-java-core ];
    nvimSkipModule = [
      # Requires the `java.utils.ui` module which seems to be provided by `nvim-java` (cyclic dependency)
      # -> Skip to avoid infinite recursion
      "java-refactor.action"
      "java-refactor.refactor"
    ];
  };

  nvim-java-test = super.nvim-java-test.overrideAttrs {
    dependencies = [ self.nvim-java-core ];
  };

  nvim-julia-autotest = callPackage ./non-generated/nvim-julia-autotest { };

  nvim-lsp-file-operations = super.nvim-lsp-file-operations.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  nvim-lsputils = super.nvim-lsputils.overrideAttrs {
    dependencies = [ self.popfix ];
  };

  nvim-metals = super.nvim-metals.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    dontBuild = true;
  };

  nvim-moonwalk = super.nvim-moonwalk.overrideAttrs {
    # Asserts log file exists before it is created
    nvimSkipModule = "moonwalk";
  };

  nvim-navbuddy = super.nvim-navbuddy.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      nvim-lspconfig
      nvim-navic
    ];
  };

  nvim-neoclip-lua = super.nvim-neoclip-lua.overrideAttrs {
    nvimSkipModule = [
      # Optional dependencies
      "neoclip.fzf"
      "neoclip.telescope"
    ];
  };

  nvim-nonicons = super.nvim-nonicons.overrideAttrs {
    # Requires web-devicons but mini.icons can mock them up
    checkInputs = [ self.nvim-web-devicons ];
  };

  nvim-nu = super.nvim-nu.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      none-ls-nvim
    ];
  };

  vim-mediawiki-editor = super.vim-mediawiki-editor.overrideAttrs {
    passthru.python3Dependencies = [ python3.pkgs.mwclient ];
  };

  nvim-navic = super.nvim-navic.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  nvim-notify = super.nvim-notify.overrideAttrs {
    # Optional fzf integration
    nvimSkipModule = "notify.integrations.fzf";
  };

  nvim-paredit = super.nvim-paredit.overrideAttrs {
    dependencies = with self; [ nvim-treesitter ];
  };

  nvim-rip-substitute = super.nvim-rip-substitute.overrideAttrs {
    buildInputs = [ ripgrep ];
  };

  nvim-scissors = super.nvim-scissors.overrideAttrs {
    checkInputs = [
      # Optional telescope picker
      self.telescope-nvim
    ];
  };

  nvim-snippets = super.nvim-snippets.overrideAttrs {
    # Optional cmp integration
    nvimSkipModule = "snippets.utils.cmp";
  };

  nvim-spectre = callPackage ./non-generated/nvim-spectre { };

  nvim-surround = super.nvim-surround.overrideAttrs {
    # Optional treesitter integration
    nvimSkipModule = "nvim-surround.queries";
  };

  nvim-teal-maker = super.nvim-teal-maker.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/tealmaker/init.lua \
        --replace-fail cyan ${luaPackages.cyan}/bin/cyan
    '';
    vimCommandCheck = "TealBuild";
  };

  nvim-tree-lua = super.nvim-tree-lua.overrideAttrs {
    nvimSkipModule = [
      # Meta can't be required
      "nvim-tree._meta.api"
      "nvim-tree._meta.api_decorator"
    ];
  };

  nvim-treesitter = super.nvim-treesitter.overrideAttrs (
    callPackage ./nvim-treesitter/overrides.nix { } self super
  );

  nvim-treesitter-context = super.nvim-treesitter-context.overrideAttrs {
    # Meant for CI installing parsers
    nvimSkipModule = "install_parsers";
  };

  nvim-treesitter-endwise = super.nvim-treesitter-endwise.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-pairs = super.nvim-treesitter-pairs.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-parsers = lib.recurseIntoAttrs self.nvim-treesitter.grammarPlugins;

  nvim-treesitter-pyfold = super.nvim-treesitter-pyfold.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-refactor = super.nvim-treesitter-refactor.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-sexp = super.nvim-treesitter-sexp.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-textobjects = super.nvim-treesitter-textobjects.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-textsubjects = super.nvim-treesitter-textsubjects.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-trevJ-lua = super.nvim-trevJ-lua.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-test = super.nvim-test.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      nvim-treesitter-parsers.c_sharp
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.haskell
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.ruby
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.zig
    ];
    nvimSkipModule = [
      # Optional toggleterm integration
      "nvim-test.terms.toggleterm"
      # Broken runners
      "nvim-test.runners.zig"
      "nvim-test.runners.hspec"
      "nvim-test.runners.stack"
    ];
  };

  nvim-ufo = super.nvim-ufo.overrideAttrs {
    dependencies = [ self.promise-async ];
  };

  nvim-unception = super.nvim-unception.overrideAttrs {
    # Attempt rpc socket connection
    nvimSkipModule = "client.client";
  };

  nvzone-menu = super.nvzone-menu.overrideAttrs {
    dependencies = [ self.nvzone-volt ];
    # Optional nvimtree integration
    nvimSkipModule = "menus.nvimtree";
  };

  nvzone-minty = super.nvzone-minty.overrideAttrs {
    dependencies = [ self.nvzone-volt ];
  };

  obsidian-nvim = super.obsidian-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional pickers
      fzf-lua
      telescope-nvim
      mini-nvim
    ];
    dependencies = [ self.plenary-nvim ];
  };

  octo-nvim = super.octo-nvim.overrideAttrs {
    checkInputs = with self; [
      # Pickers, can use telescope or fzf-lua
      fzf-lua
      telescope-nvim
    ];
    dependencies = with self; [
      plenary-nvim
    ];
  };

  ollama-nvim = super.ollama-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  onehalf = super.onehalf.overrideAttrs {
    configurePhase = "cd vim";
  };

  omni-vim = super.omni-vim.overrideAttrs {
    # Optional lightline integration
    nvimSkipModule = "omni-lightline";
  };

  onedark-nvim = super.onedark-nvim.overrideAttrs {
    nvimSkipModule = [
      # Requires global config value
      "barbecue.theme.onedark"
      "onedark.highlights"
      "onedark.colors"
      "onedark.terminal"
    ];
  };

  one-nvim = super.one-nvim.overrideAttrs {
    # E5108: /lua/one-nvim.lua:14: Unknown option 't_Co'
    # https://github.com/Th3Whit3Wolf/one-nvim/issues/23
    meta.broken = true;
  };

  # The plugin depends on either skim-vim or fzf-vim, but we don't want to force the user so we
  # avoid choosing one of them and leave it to the user
  openscad-nvim = super.openscad-nvim.overrideAttrs {
    buildInputs = [
      zathura
      htop
      openscad
    ];

    # FIXME: can't find plugin root dir
    nvimSkipModule = [
      "openscad"
      "openscad.snippets.openscad"
      "openscad.utilities"
    ];
    patches = [
      (replaceVars ./patches/openscad.nvim/program_paths.patch {
        htop = lib.getExe htop;
        openscad = lib.getExe openscad;
        zathura = lib.getExe zathura;
      })
    ];
  };

  otter-nvim = super.otter-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  outline-nvim = super.outline-nvim.overrideAttrs {
    # Requires setup call
    nvimSkipModule = "outline.providers.norg";
  };

  overseer-nvim = super.overseer-nvim.overrideAttrs {
    checkInputs = [
      # Optional integration
      self.neotest
    ];
    checkPhase = ''
      runHook preCheck

      plugins=.testenv/data/nvim/site/pack/plugins/start
      mkdir -p "$plugins"
      ln -s ${self.plenary-nvim} "$plugins/plenary.nvim"
      bash run_tests.sh
      rm -r .testenv

      runHook postCheck
    '';
    nvimSkipModule = [
      # Optional integrations
      "overseer.strategy.toggleterm"
      "overseer.dap"
    ];
  };

  package-info-nvim = super.package-info-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  inherit parinfer-rust;

  parpar-nvim = super.parpar-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-parinfer
      nvim-paredit
      nvim-treesitter
    ];
  };

  persisted-nvim = super.persisted-nvim.overrideAttrs {
    nvimSkipModule = [
      # /lua/persisted/init.lua:44: attempt to index upvalue 'config' (a nil value)
      # https://github.com/olimorris/persisted.nvim/issues/146
      "persisted"
      "persisted.config"
      "persisted.utils"
    ];
  };

  phpactor = buildVimPlugin {
    inherit (phpactor)
      pname
      src
      meta
      version
      ;
    postPatch = ''
      substituteInPlace plugin/phpactor.vim \
        --replace-fail "g:phpactorpath = expand('<sfile>:p:h') . '/..'" "g:phpactorpath = '${phpactor}'"
    '';
  };

  playground = super.playground.overrideAttrs {
    dependencies = with self; [
      # we need the 'query' grammar to make
      (nvim-treesitter.withPlugins (p: [ p.query ]))
    ];
  };

  plenary-nvim = neovimUtils.buildNeovimPlugin {
    luaAttr = luaPackages.plenary-nvim;
    runtimeDeps = [ curl ];
  };

  poimandres-nvim = super.poimandres-nvim.overrideAttrs {
    # Optional treesitter support
    nvimSkipModule = "poimandres.highlights";
  };

  popup-nvim = super.popup-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  Preview-nvim = super.Preview-nvim.overrideAttrs {
    patches = [
      (replaceVars ./patches/preview-nvim/hardcode-mdt-binary-path.patch {
        mdt = lib.getExe md-tui;
      })
    ];
  };

  pywal-nvim = super.pywal-nvim.overrideAttrs {
    # Optional feline integration
    nvimSkipModule = "pywal.feline";
  };

  qmk-nvim = super.qmk-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Test assertions
      "qmk.config.init_spec"
      "qmk.format.keymap_spec"
      "qmk.format.qmk_spec"
      "qmk.format.zmk_spec"
      "qmk.parse.qmk.init_spec"
      "qmk.parse.zmk.init_spec"
      "qmk_spec"
    ];
  };

  quicker-nvim = super.quicker-nvim.overrideAttrs {
  };

  rainbow-delimiters-nvim = callPackage ./non-generated/rainbow-delimiters-nvim { };

  range-highlight-nvim = super.range-highlight-nvim.overrideAttrs {
    dependencies = [ self.cmd-parser-nvim ];
  };

  ranger-nvim = super.ranger-nvim.overrideAttrs {
    patches = [ ./patches/ranger.nvim/fix-paths.patch ];

    postPatch = ''
      substituteInPlace lua/ranger-nvim.lua --replace-fail '@ranger@' ${ranger}/bin/ranger
    '';
  };

  aider-nvim = super.aider-nvim.overrideAttrs {
    patches = [
      (replaceVars ./patches/aider-nvim/bin.patch { aider = lib.getExe' aider-chat "aider"; })
    ];
  };

  refactoring-nvim = super.refactoring-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      plenary-nvim
    ];
  };

  remote-nvim-nvim = super.remote-nvim-nvim.overrideAttrs {
    dontPatchShebangs = true;
    dependencies = with self; [
      nui-nvim
      plenary-nvim
    ];
    nvimSkipModule = "repro";
  };

  remote-sshfs-nvim = super.remote-sshfs-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      plenary-nvim
    ];
    runtimeDeps = [
      openssh
      sshfs
    ];
  };

  renamer-nvim = super.renamer-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  repolink-nvim = super.repolink-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  # needs  "http" and "json" treesitter grammars too
  rest-nvim = super.rest-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      (nvim-treesitter.withPlugins (p: [
        p.http
        p.json
      ]))
    ];
  };

  rustaceanvim = neovimUtils.buildNeovimPlugin {
    checkInputs = [
      # Optional integration
      self.neotest
    ];
    luaAttr = luaPackages.rustaceanvim;
  };

  rust-tools-nvim = super.rust-tools-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  rzls-nvim = super.rzls-nvim.overrideAttrs {
    dependencies = [ self.roslyn-nvim ];
  };

  samodostal-image-nvim = super.samodostal-image-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  scretch-nvim = super.scretch-nvim.overrideAttrs {
  };

  searchbox-nvim = super.searchbox-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  sg-nvim = callPackage ./non-generated/sg-nvim { };

  skim = buildVimPlugin {
    pname = "skim";
    inherit (skim) version;
    src = skim.vim;
  };

  skim-vim = super.skim-vim.overrideAttrs {
    dependencies = [ self.skim ];
  };

  smart-open-nvim = super.smart-open-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      sqlite-lua
      telescope-nvim
    ];
    nvimSkipModule = [
      # optional dependency
      "smart-open.matching.algorithms.fzf_implementation"
    ];
  };

  smart-splits-nvim = super.smart-splits-nvim.overrideAttrs {
    nvimSkipModule = [
      "vimdoc-gen"
      "vimdocrc"
    ];
  };

  snacks-nvim = super.snacks-nvim.overrideAttrs {
    nvimSkipModule = [
      # Requires setup call first
      # attempt to index global 'Snacks' (a nil value)
      "snacks.dashboard"
      "snacks.debug"
      "snacks.dim"
      "snacks.git"
      "snacks.image.convert"
      "snacks.image.image"
      "snacks.image.init"
      "snacks.image.placement"
      "snacks.indent"
      "snacks.input"
      "snacks.lazygit"
      "snacks.notifier"
      "snacks.picker.actions"
      "snacks.picker.config.highlights"
      "snacks.picker.core.list"
      "snacks.scratch"
      "snacks.scroll"
      "snacks.terminal"
      "snacks.win"
      "snacks.words"
      "snacks.zen"
      # Optional trouble integration
      "trouble.sources.profiler"
      # TODO: Plugin requires libsqlite available, create a test for it
      "snacks.picker.util.db"
    ];
  };

  snap = super.snap.overrideAttrs {
    nvimSkipModule = [
      "snap.consumer.fzy.all"
      "snap.consumer.fzy.filter"
      "snap.consumer.fzy.init"
      "snap.consumer.fzy.positions"
      "snap.consumer.fzy.score"
      # circular import
      "snap.producer.create"
      # https://github.com/camspiers/snap/pull/97
      "snap.preview.help"
      "snap.producer.vim.help"
    ];
  };

  sniprun = callPackage ./non-generated/sniprun { };

  # The GitHub repository returns 404, which breaks the update script
  Spacegray-vim = buildVimPlugin {
    pname = "Spacegray.vim";
    version = "2021-07-06";
    src = fetchFromGitHub {
      owner = "ackyshake";
      repo = "Spacegray.vim";
      rev = "c699ca10ed421c462bd1c87a158faaa570dc8e28";
      sha256 = "0ma8w6p5jh6llka49x5j5ql8fmhv0bx5hhsn5b2phak79yqg1k61";
    };
    meta.homepage = "https://github.com/ackyshake/Spacegray.vim/";
  };

  spaceman-nvim = super.spaceman-nvim.overrideAttrs {
    # Optional telescope integration
    nvimSkipModule = "spaceman.adapters.telescope";
  };

  sqlite-lua = super.sqlite-lua.overrideAttrs (
    oa:
    let
      libsqlite = "${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}";
    in
    {
      postPatch = ''
        substituteInPlace lua/sqlite/defs.lua \
          --replace-fail "path = vim.g.sqlite_clib_path" "path = vim.g.sqlite_clib_path or '${lib.escapeShellArg libsqlite}'"
      '';

      passthru = oa.passthru // {
        initLua = ''vim.g.sqlite_clib_path = "${libsqlite}"'';
      };

      nvimSkipModule = [
        # Require "sql.utils" ?
        "sqlite.tbl.cache"
        # attempt to write to read only database
        "sqlite.examples.bookmarks"
      ];
    }
  );

  ssr = super.ssr-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  startup-nvim = super.startup-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  statix = buildVimPlugin rec {
    inherit (statix) pname src meta;
    version = "0.1.0";
    postPatch = ''
      # check that version is up to date
      grep 'pname = "statix-vim"' -A 1 flake.nix \
        | grep -F 'version = "${version}"'

      cd vim-plugin
      substituteInPlace ftplugin/nix.vim --replace-fail statix ${statix}/bin/statix
      substituteInPlace plugin/statix.vim --replace-fail statix ${statix}/bin/statix
    '';
  };

  stylish-nvim = super.stylish-nvim.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/stylish/common/mouse_hover_handler.lua --replace-fail xdotool ${xdotool}/bin/xdotool
      substituteInPlace lua/stylish/components/menu.lua --replace-fail xdotool ${xdotool}/bin/xdotool
      substituteInPlace lua/stylish/components/menu.lua --replace-fail xwininfo ${xorg.xwininfo}/bin/xwininfo
    '';
  };

  supermaven-nvim = super.supermaven-nvim.overrideAttrs {
    # TODO: handle supermaven binary
    doCheck = false;
  };

  sved =
    let
      # we put the script in its own derivation to benefit the magic of wrapGAppsHook3
      svedbackend = stdenv.mkDerivation {
        name = "svedbackend-${super.sved.name}";
        inherit (super.sved) src;
        nativeBuildInputs = [
          wrapGAppsHook3
          gobject-introspection
        ];
        buildInputs = [
          glib
          (python3.withPackages (
            ps: with ps; [
              pygobject3
              pynvim
              dbus-python
            ]
          ))
        ];
        preferLocalBuild = true;
        installPhase = ''
          install -Dt $out/bin ftplugin/evinceSync.py
        '';
      };
      # the vim plugin expects evinceSync.py to be a python file, but it is a C wrapper
      pythonWrapper =
        writeText "evinceSync-wrapper.py" # python
          ''
            #!${python3}/bin/python3
            import os
            import sys
            os.execv("${svedbackend}/bin/evinceSync.py", sys.argv)
          '';
    in
    super.sved.overrideAttrs {
      preferLocalBuild = true;
      postPatch = ''
        rm ftplugin/evinceSync.py
        install -m 544 ${pythonWrapper} ftplugin/evinceSync.py
      '';
      meta = {
        description = "synctex support between vim/neovim and evince";
      };
    };

  syntax-tree-surfer = super.syntax-tree-surfer.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
    meta.maintainers = with lib.maintainers; [ callumio ];
  };

  taskwarrior3 = buildVimPlugin {
    inherit (taskwarrior3) version pname;
    src = "${taskwarrior3.src}/scripts/vim";
  };

  taskwarrior2 = buildVimPlugin {
    inherit (taskwarrior2) version pname;
    src = "${taskwarrior2.src}/scripts/vim";
  };

  telekasten-nvim = super.telekasten-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-asynctasks-nvim = super.telescope-asynctasks-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-cheat-nvim = super.telescope-cheat-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      sqlite-lua
      telescope-nvim
    ];
  };

  telescope-coc-nvim = super.telescope-coc-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-dap-nvim = super.telescope-dap-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      nvim-dap
      telescope-nvim
    ];
  };

  telescope-emoji-nvim = super.telescope-emoji-nvim.overrideAttrs {
    dependencies = [ self.telescope-nvim ];
  };

  telescope-frecency-nvim = super.telescope-frecency-nvim.overrideAttrs {
    dependencies = with self; [
      sqlite-lua
      telescope-nvim
      plenary-nvim
    ];
    # Meta
    nvimSkipModule = "frecency.types";
  };

  telescope-fzf-native-nvim = super.telescope-fzf-native-nvim.overrideAttrs {
    dependencies = [ self.telescope-nvim ];
    buildPhase = "make";
    meta.platforms = lib.platforms.all;
  };

  telescope-fzf-writer-nvim = super.telescope-fzf-writer-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-fzy-native-nvim = super.telescope-fzy-native-nvim.overrideAttrs (old: {
    dependencies = [ self.telescope-nvim ];
    preFixup =
      let
        fzy-lua-native-path = "deps/fzy-lua-native";
        fzy-lua-native = stdenv.mkDerivation {
          name = "fzy-lua-native";
          src = "${old.src}/${fzy-lua-native-path}";
          # remove pre-compiled binaries
          preBuild = "rm -rf static/*";
          installPhase = ''
            install -Dm 444 -t $out/static static/*
            install -Dm 444 -t $out/lua lua/*
          '';
        };
      in
      ''
        rm -rf $target/${fzy-lua-native-path}/*
        ln -s ${fzy-lua-native}/static $target/${fzy-lua-native-path}/static
        ln -s ${fzy-lua-native}/lua $target/${fzy-lua-native-path}/lua
      '';
    meta.platforms = lib.platforms.all;
  });

  telescope-git-conflicts-nvim = super.telescope-git-conflicts-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-github-nvim = super.telescope-github-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-glyph-nvim = super.telescope-github-nvim.overrideAttrs {
    dependencies = [ self.telescope-nvim ];
  };

  telescope-live-grep-args-nvim = super.telescope-live-grep-args-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-lsp-handlers-nvim = super.telescope-lsp-handlers-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-media-files-nvim = super.telescope-media-files-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      popup-nvim
      plenary-nvim
    ];
  };

  telescope-project-nvim = super.telescope-project-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  telescope-nvim = super.telescope-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  telescope-smart-history-nvim = super.telescope-smart-history-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-symbols-nvim = super.telescope-symbols-nvim.overrideAttrs {
    dependencies = [ self.telescope-nvim ];
  };

  telescope-ui-select-nvim = super.telescope-ui-select-nvim.overrideAttrs {
    dependencies = [ self.telescope-nvim ];
  };

  telescope-ultisnips-nvim = super.telescope-ultisnips-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-undo-nvim = super.telescope-undo-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-vim-bookmarks-nvim = super.telescope-vim-bookmarks-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-z-nvim = super.telescope-z-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  telescope-zf-native-nvim = super.telescope-zf-native-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
  };

  quarto-nvim = super.quarto-nvim.overrideAttrs {
    checkInputs = [
      # Optional runner
      self.iron-nvim
    ];
    dependencies = with self; [
      nvim-lspconfig
      otter-nvim
    ];
  };

  telescope-zoxide = super.telescope-zoxide.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];

    buildInputs = [ zoxide ];

    postPatch = ''
      substituteInPlace lua/telescope/_extensions/zoxide/config.lua \
        --replace-fail "zoxide query -ls" "${zoxide}/bin/zoxide query -ls"
    '';
  };

  text-case-nvim = super.text-case-nvim.overrideAttrs {
    nvimSkipModule = [
      # some leftover from development
      "textcase.plugin.range"
    ];
  };

  tmux-complete-vim = super.tmux-complete-vim.overrideAttrs {
    # Vim plugin with optional nvim-compe lua module
    nvimSkipModule = "compe_tmux";
  };

  todo-comments-nvim = super.todo-comments-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional trouble integration
      trouble-nvim
    ];
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Optional fzf-lua integration
      # fzf-lua server must be running
      "todo-comments.fzf"
    ];
  };

  tokyonight-nvim = super.tokyonight-nvim.overrideAttrs {
    nvimSkipModule = [
      # Meta file
      "tokyonight.docs"
      # Optional integration
      "tokyonight.extra.fzf"
    ];
  };

  triptych-nvim = super.triptych-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  tsc-nvim = super.tsc-nvim.overrideAttrs {
    patches = [ ./patches/tsc.nvim/fix-path.patch ];

    postPatch = ''
      substituteInPlace lua/tsc/utils.lua --replace-fail '@tsc@' ${typescript}/bin/tsc
    '';

    # Unit test
    nvimSkipModule = "tsc.better-messages-test";
  };

  trouble-nvim = super.trouble-nvim.overrideAttrs {
    # Meta file
    nvimSkipModule = "trouble.docs";
  };

  tssorter-nvim = super.tssorter-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  tup =
    let
      # Based on the comment at the top of https://github.com/gittup/tup/blob/master/contrib/syntax/tup.vim
      ftdetect = builtins.toFile "tup.vim" ''
        au BufNewFile,BufRead Tupfile,*.tup setf tup
      '';
    in
    buildVimPlugin {
      inherit (tup) pname version src;
      preInstall = ''
        mkdir -p vim-plugin/syntax vim-plugin/ftdetect
        cp contrib/syntax/tup.vim vim-plugin/syntax/tup.vim
        cp "${ftdetect}" vim-plugin/ftdetect/tup.vim
        cd vim-plugin
      '';
      meta.maintainers = with lib.maintainers; [ enderger ];
    };

  typescript-nvim = super.typescript-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-lspconfig
    ];
    # Optional null-ls integration
    nvimSkipModule = [ "typescript.extensions.null-ls.code-actions.init" ];
  };

  typescript-tools-nvim = super.typescript-tools-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-lspconfig
      plenary-nvim
    ];
    runtimeDeps = [
      typescript-language-server
    ];
  };

  nvzone-typr = super.nvzone-typr.overrideAttrs {
    dependencies = [ self.nvzone-volt ];
  };

  unicode-vim =
    let
      unicode-data = fetchurl {
        url = "http://www.unicode.org/Public/UNIDATA/UnicodeData.txt";
        sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
      };
    in
    super.unicode-vim.overrideAttrs (oa: {
      # redirect to /dev/null else changes terminal color
      buildPhase = ''
        cp "${unicode-data}" autoload/unicode/UnicodeData.txt
        echo "Building unicode cache"
        ${vim}/bin/vim --cmd ":set rtp^=$PWD" -c 'ru plugin/unicode.vim' -c 'UnicodeCache' -c ':echohl Normal' -c ':q' > /dev/null
      '';

      passthru = oa.passthru // {

        initLua = ''vim.g.Unicode_data_directory="${self.unicode-vim}/autoload/unicode"'';
      };
    });

  unison = super.unison.overrideAttrs {
    # Editor stuff isn't at top level
    postPatch = "cd editor-support/vim";
  };

  vCoolor-vim = super.vCoolor-vim.overrideAttrs {
    # on linux can use either Zenity or Yad.
    propagatedBuildInputs = [ zenity ];
    meta = {
      description = "Simple color selector/picker plugin";
      license = lib.licenses.publicDomain;
    };
  };

  vimade = super.vimade.overrideAttrs {
    checkInputs = with self; [
      # Optional providers
      hlchunk-nvim
      mini-nvim
      snacks-nvim
    ];
  };

  vim-addon-actions = super.vim-addon-actions.overrideAttrs {
    dependencies = with self; [
      vim-addon-mw-utils
      tlib_vim
    ];
  };

  vim-addon-async = super.vim-addon-async.overrideAttrs {
    dependencies = [ self.vim-addon-signs ];
  };

  vim-addon-background-cmd = super.vim-addon-background-cmd.overrideAttrs {
    dependencies = [ self.vim-addon-mw-utils ];
  };

  vim-addon-completion = super.vim-addon-completion.overrideAttrs {
    dependencies = [ self.tlib_vim ];
  };

  vim-addon-goto-thing-at-cursor = super.vim-addon-goto-thing-at-cursor.overrideAttrs {
    dependencies = [ self.tlib_vim ];
  };

  vim-addon-mru = super.vim-addon-mru.overrideAttrs {
    dependencies = with self; [
      vim-addon-other
      vim-addon-mw-utils
    ];
  };

  vim-addon-nix = super.vim-addon-nix.overrideAttrs {
    dependencies = with self; [
      vim-addon-completion
      vim-addon-goto-thing-at-cursor
      vim-addon-errorformats
      vim-addon-actions
      vim-addon-mw-utils
      tlib_vim
    ];
  };

  vim-addon-sql = super.vim-addon-sql.overrideAttrs {
    dependencies = with self; [
      vim-addon-completion
      vim-addon-background-cmd
      tlib_vim
    ];
  };

  vim-addon-syntax-checker = super.vim-addon-syntax-checker.overrideAttrs {
    dependencies = with self; [
      vim-addon-mw-utils
      tlib_vim
    ];
  };

  vim-addon-toggle-buffer = super.vim-addon-toggle-buffer.overrideAttrs {
    dependencies = with self; [
      vim-addon-mw-utils
      tlib_vim
    ];
  };

  vim-addon-xdebug = super.vim-addon-xdebug.overrideAttrs {
    dependencies = with self; [
      webapi-vim
      vim-addon-mw-utils
      vim-addon-signs
      vim-addon-async
    ];
  };

  vim-agda = super.vim-agda.overrideAttrs {
    preFixup = ''
      substituteInPlace "$out"/autoload/agda.vim \
        --replace-fail "jobstart(['agda'" "jobstart(['${agda}/bin/agda'"
    '';
  };

  vim-apm = super.vim-apm.overrideAttrs {
    nvimSkipModule = "run";
  };

  vim-bazel = super.vim-bazel.overrideAttrs {
    dependencies = [ self.vim-maktaba ];
  };

  vim-beancount = super.vim-beancount.overrideAttrs {
    passthru.python3Dependencies = ps: with ps; [ beancount ];
  };

  vim-clap = callPackage ./non-generated/vim-clap { };

  vim-codefmt = super.vim-codefmt.overrideAttrs {
    dependencies = [ self.vim-maktaba ];
  };

  # Due to case-sensitivity issues, the hash differs on Darwin systems, see:
  # https://github.com/NixOS/nixpkgs/issues/157609
  vim-colorschemes = super.vim-colorschemes.overrideAttrs (old: {
    src = old.src.overrideAttrs (srcOld: {
      postFetch =
        (srcOld.postFetch or "")
        + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
          rm $out/colors/darkBlue.vim
        '';
    });
  });

  vim-dadbod-ui = super.vim-dadbod-ui.overrideAttrs {
    dependencies = [ self.vim-dadbod ];

    doInstallCheck = true;
    vimCommandCheck = "DBUI";
  };

  vim-dasht = super.vim-dasht.overrideAttrs {
    preFixup = ''
      substituteInPlace $out/autoload/dasht.vim \
        --replace-fail "['dasht']" "['${dasht}/bin/dasht']"
    '';
  };

  vim-easytags = super.vim-easytags.overrideAttrs {
    dependencies = [ self.vim-misc ];
    patches = [
      (fetchpatch {
        # https://github.com/xolox/vim-easytags/pull/170 fix version detection for universal-ctags
        url = "https://github.com/xolox/vim-easytags/commit/46e4709500ba3b8e6cf3e90aeb95736b19e49be9.patch";
        sha256 = "0x0xabb56xkgdqrg1mpvhbi3yw4d829n73lsnnyj5yrxjffy4ax4";
      })
    ];
  };

  vim-flog = super.vim-flog.overrideAttrs {
    # Not intended to be required, used by vim plugin
    nvimSkipModule = "flog.graph_bin";
  };

  vim-fzf-coauthorship = super.vim-fzf-coauthorship.overrideAttrs {
    dependencies = with self; [ fzf-vim ];
  };

  # change the go_bin_path to point to a path in the nix store. See the code in
  # fatih/vim-go here
  # https://github.com/fatih/vim-go/blob/155836d47052ea9c9bac81ba3e937f6f22c8e384/autoload/go/path.vim#L154-L159
  vim-go =
    let
      binPath = lib.makeBinPath [
        asmfmt
        delve
        errcheck
        go-motion
        go-tools # contains staticcheck, keyify
        gocode-gomod
        godef
        gogetdoc
        golint
        golangci-lint
        gomodifytags
        gopls
        gotags
        gotools # contains guru, gorename
        iferr
        impl
        reftools
        revive
      ];
    in
    super.vim-go.overrideAttrs {
      postPatch = ''
        sed -i autoload/go/config.vim -Ee 's@"go_bin_path", ""@"go_bin_path", "${binPath}"@g'
      '';
    };

  vim-gist = super.vim-gist.overrideAttrs {
    dependencies = [ self.webapi-vim ];
  };

  vim-grammarous = super.vim-grammarous.overrideAttrs {
    # use `:GrammarousCheck` to initialize checking
    # In neovim, you also want to use set
    #   let g:grammarous#show_first_error = 1
    # see https://github.com/rhysd/vim-grammarous/issues/39
    patches = [
      (replaceVars ./patches/vim-grammarous/set_default_languagetool.patch {
        inherit languagetool;
      })
    ];
  };

  vim-hexokinase = super.vim-hexokinase.overrideAttrs (old: {
    preFixup =
      let
        hexokinase = buildGoModule {
          name = "hexokinase";
          src = old.src + "/hexokinase";
          vendorHash = null;
        };
      in
      ''
        ln -s ${hexokinase}/bin/hexokinase $target/hexokinase/hexokinase
      '';

    meta.platforms = lib.platforms.all;
  });

  vim-hier = super.vim-hier.overrideAttrs {
    buildInputs = [ vim ];
  };

  vim-illuminate = super.vim-illuminate.overrideAttrs {
    # Optional treesitter integration
    nvimSkipModule = "illuminate.providers.treesitter";
  };

  vim-isort = super.vim-isort.overrideAttrs {
    postPatch = ''
      substituteInPlace ftplugin/python_vimisort.vim \
        --replace-fail 'import vim' 'import vim; import sys; sys.path.append("${python3.pkgs.isort}/${python3.sitePackages}")'
    '';
  };

  vim-markdown-composer = callPackage ./non-generated/vim-markdown-composer { };

  vim-matchup = super.vim-matchup.overrideAttrs {
    # Optional treesitter integration
    nvimSkipModule = "treesitter-matchup.third-party.query";
  };

  vim-metamath = super.vim-metamath.overrideAttrs {
    preInstall = "cd vim";
  };

  vim-pluto = super.vim-pluto.overrideAttrs {
    dependencies = [ self.denops-vim ];
  };

  # The GitHub repository returns 404, which breaks the update script
  vim-pony = buildVimPlugin {
    pname = "vim-pony";
    version = "2018-07-27";
    src = fetchFromGitHub {
      owner = "jakwings";
      repo = "vim-pony";
      rev = "b26f01a869000b73b80dceabd725d91bfe175b75";
      sha256 = "0if8g94m3xmpda80byfxs649w2is9ah1k8v3028nblan73zlc8x8";
    };
    meta.homepage = "https://github.com/jakwings/vim-pony/";
  };

  vim-sensible = super.vim-sensible.overrideAttrs {
    patches = [ ./patches/vim-sensible/fix-nix-store-path-regex.patch ];
  };

  vim-snipmate = super.vim-snipmate.overrideAttrs {
    dependencies = with self; [
      vim-addon-mw-utils
      tlib_vim
    ];
  };

  vim-speeddating = super.vim-speeddating.overrideAttrs {
    dependencies = [ self.vim-repeat ];
  };

  vim-stationeers-ic10-syntax = callPackage ./non-generated/vim-stationeers-ic10-syntax { };

  vim-stylish-haskell = super.vim-stylish-haskell.overrideAttrs (old: {
    postPatch =
      old.postPatch or ""
      + ''
        substituteInPlace ftplugin/haskell/stylish-haskell.vim --replace-fail \
          'g:stylish_haskell_command = "stylish-haskell"' \
          'g:stylish_haskell_command = "${stylish-haskell}/bin/stylish-haskell"'
      '';
  });

  vim-surround = super.vim-surround.overrideAttrs {
    dependencies = [ self.vim-repeat ];
  };

  vim-tabby = super.vim-tabby.overrideAttrs {
  };

  vim-textobj-entire = super.vim-textobj-entire.overrideAttrs {
    dependencies = [ self.vim-textobj-user ];
    meta.maintainers = with lib.maintainers; [ farlion ];
  };

  vim-tpipeline = super.vim-tpipeline.overrideAttrs {
    # Requires global variable
    nvimSkipModule = "tpipeline.main";
  };

  vim-unimpaired = super.vim-unimpaired.overrideAttrs {
    dependencies = [ self.vim-repeat ];
  };

  vim-wakatime = super.vim-wakatime.overrideAttrs {
    buildInputs = [ python3 ];
    patchPhase = ''
      substituteInPlace plugin/wakatime.vim \
        --replace-fail 'autocmd BufEnter,VimEnter' \
                       'autocmd VimEnter' \
        --replace-fail 'autocmd CursorHold,CursorHoldI' \
                       'autocmd CursorHold,CursorHoldI,BufEnter'
    '';
  };

  vim-xdebug = super.vim-xdebug.overrideAttrs {
    postInstall = null;
  };

  vim-xkbswitch = super.vim-xkbswitch.overrideAttrs {
    buildInputs = [ xkb-switch ];
  };

  vim-yapf = super.vim-yapf.overrideAttrs {
    buildPhase = ''
      substituteInPlace ftplugin/python_yapf.vim \
        --replace-fail '"yapf"' '"${python3.pkgs.yapf}/bin/yapf"'
    '';
  };

  vim2nix = buildVimPlugin {
    pname = "vim2nix";
    version = "1.0";
    src = ./vim2nix;
    dependencies = [ self.vim-addon-manager ];
  };

  vimacs = super.vimacs.overrideAttrs {
    buildPhase = ''
      substituteInPlace bin/vim \
        --replace-fail '/usr/bin/vim' 'vim' \
        --replace-fail '/usr/bin/gvim' 'gvim'
      # remove unnecessary duplicated bin wrapper script
      rm -r plugin/vimacs
    '';
    meta = with lib; {
      description = "Vim-Improved eMACS: Emacs emulation plugin for Vim";
      homepage = "http://algorithm.com.au/code/vimacs";
      license = licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ millerjason ];
    };
  };

  # The GitHub repository returns 404, which breaks the update script
  VimCompletesMe = buildVimPlugin {
    pname = "VimCompletesMe";
    version = "2022-02-18";
    src = fetchFromGitHub {
      owner = "ackyshake";
      repo = "VimCompletesMe";
      rev = "9adf692d7ae6424038458a89d4a411f0a27d1388";
      sha256 = "1sndgb3291dyifaa8adri2mb8cgbinbar3nw1fnf67k9ahwycaz0";
    };
    meta.homepage = "https://github.com/ackyshake/VimCompletesMe/";
  };

  vimsence = super.vimsence.overrideAttrs {
    meta = with lib; {
      description = "Discord rich presence for Vim";
      homepage = "https://github.com/hugolgst/vimsence";
      maintainers = with lib.maintainers; [ hugolgst ];
    };
  };

  vimproc-vim = super.vimproc-vim.overrideAttrs {
    buildInputs = [ which ];

    # TODO: revisit
    buildPhase = ''
      substituteInPlace autoload/vimproc.vim \
        --replace-fail vimproc_mac.so vimproc_unix.so \
        --replace-fail vimproc_linux64.so vimproc_unix.so \
        --replace-fail vimproc_linux32.so vimproc_unix.so
      make -f make_unix.mak
    '';
  };

  vimshell-vim = super.vimshell-vim.overrideAttrs {
    dependencies = [ self.vimproc-vim ];
  };

  vim-ultest = super.vim-ultest.overrideAttrs {
    # NOTE: vim-ultest is no longer maintained.
    # If using Neovim, you can switch to using neotest (https://github.com/nvim-neotest/neotest) instead.
    nvimSkipModule = "ultest";
  };

  vim-zettel = super.vim-zettel.overrideAttrs {
    dependencies = with self; [
      vimwiki
      fzf-vim
    ];
  };

  virt-column-nvim = super.virt-column-nvim.overrideAttrs {
    # Meta file
    nvimSkipModule = "virt-column.config.types";
  };

  which-key-nvim = super.which-key-nvim.overrideAttrs {
    nvimSkipModule = [ "which-key.docs" ];
  };

  wiki-vim = super.wiki-vim.overrideAttrs {
    # Optional telescope integration
    nvimSkipModule = [ "wiki.telescope" ];
  };

  windows-nvim = super.windows-nvim.overrideAttrs {
    dependencies = with self; [
      middleclass
      animation-nvim
    ];
    nvimSkipModule = [
      # Animation doesn't work headless
      "windows.autowidth"
      "windows.commands"
    ];
  };

  wtf-nvim = super.wtf-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  YankRing-vim = super.YankRing-vim.overrideAttrs {
    sourceRoot = ".";
  };

  yanky-nvim = super.yanky-nvim.overrideAttrs {
    nvimSkipModule = [
      # Optional telescope integration
      "yanky.telescope.mapping"
      "yanky.telescope.yank_history"
    ];
  };

  yazi-nvim = super.yazi-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModule = [
      # Used for reproducing issues
      "repro"
    ];
  };

  YouCompleteMe = super.YouCompleteMe.overrideAttrs {
    buildPhase = ''
      substituteInPlace plugin/youcompleteme.vim \
        --replace-fail "'ycm_path_to_python_interpreter', '''" \
        "'ycm_path_to_python_interpreter', '${python3}/bin/python3'"

      rm -r third_party/ycmd
      ln -s ${ycmd}/lib/ycmd third_party
    '';

    meta = with lib; {
      description = "Code-completion engine for Vim";
      homepage = "https://github.com/Valloric/YouCompleteMe";
      license = licenses.gpl3;
      maintainers = with maintainers; [
        marcweber
        jagajaga
        mel
      ];
      platforms = platforms.unix;
    };
  };

  zenbones-nvim = super.zenbones-nvim.overrideAttrs {
    nvimSkipModule = [
      # Requires global variable set
      "randombones"
      "randombones.palette"
      # Optional shipwright
      "zenbones.shipwright.runners.alacritty"
      "zenbones.shipwright.runners.foot"
      "zenbones.shipwright.runners.iterm"
      "zenbones.shipwright.runners.kitty"
      "zenbones.shipwright.runners.lightline"
      "zenbones.shipwright.runners.lualine"
      "zenbones.shipwright.runners.tmux"
      "zenbones.shipwright.runners.vim"
      "zenbones.shipwright.runners.wezterm"
      "zenbones.shipwright.runners.windows_terminal"
      # Optional lush-nvim integration
      "duckbones"
      "duckbones.palette"
      "forestbones"
      "forestbones.palette"
      "kanagawabones"
      "kanagawabones.palette"
      "neobones"
      "neobones.palette"
      "nordbones"
      "nordbones.palette"
      "rosebones"
      "rosebones.palette"
      "seoulbones"
      "seoulbones.palette"
      "tokyobones"
      "tokyobones.palette"
      "vimbones"
      "vimbones.palette"
      "zenbones"
      "zenbones.palette"
      "zenbones.specs.dark"
      "zenbones.specs.light"
      "zenburned"
      "zenburned.palette"
      "zenwritten"
      "zenwritten.palette"
    ];
  };

  zk-nvim = super.zk-nvim.overrideAttrs {
    # Optional integrations
    nvimSkipModule = [
      "zk.pickers.fzf_lua"
      "zk.pickers.minipick"
      "zk.pickers.snacks_picker"
      "zk.pickers.telescope"
    ];
  };

  zotcite = super.zotcite.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  zoxide-vim = super.zoxide-vim.overrideAttrs {
    buildInputs = [ zoxide ];

    postPatch = ''
      substituteInPlace autoload/zoxide.vim \
        --replace-fail "'zoxide_executable', 'zoxide'" "'zoxide_executable', '${zoxide}/bin/zoxide'"
    '';
  };

  typst-preview-nvim = super.typst-preview-nvim.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/typst-preview/config.lua \
       --replace-fail "['tinymist'] = nil," "tinymist = '${lib.getExe tinymist}'," \
       --replace-fail "['websocat'] = nil," "websocat = '${lib.getExe websocat}',"
    '';

  };
}
// (
  let
    nodePackageNames = [
      "coc-cmake"
      "coc-docker"
      "coc-emmet"
      "coc-eslint"
      "coc-explorer"
      "coc-flutter"
      "coc-git"
      "coc-go"
      "coc-haxe"
      "coc-highlight"
      "coc-html"
      "coc-java"
      "coc-jest"
      "coc-json"
      "coc-lists"
      "coc-ltex"
      "coc-markdownlint"
      "coc-pairs"
      "coc-prettier"
      "coc-r-lsp"
      "coc-rls"
      "coc-rust-analyzer"
      "coc-sh"
      "coc-smartf"
      "coc-snippets"
      "coc-solargraph"
      "coc-spell-checker"
      "coc-sqlfluff"
      "coc-stylelint"
      "coc-sumneko-lua"
      "coc-tabnine"
      "coc-texlab"
      "coc-tsserver"
      "coc-ultisnips"
      "coc-vetur"
      "coc-vimlsp"
      "coc-vimtex"
      "coc-wxml"
      "coc-yaml"
      "coc-yank"
    ];
    nodePackage2VimPackage =
      name:
      buildVimPlugin {
        pname = name;
        inherit (nodePackages.${name}) version meta;
        src = "${nodePackages.${name}}/lib/node_modules/${name}";
      };
  in
  lib.genAttrs nodePackageNames nodePackage2VimPackage
)
// (
  let
    luarocksPackageNames = [
      "fidget-nvim"
      "gitsigns-nvim"
      "image-nvim"
      "lsp-progress-nvim"
      "lualine-nvim"
      "luasnip"
      "lush-nvim"
      "lz-n"
      "lze"
      "lzextras"
      "lzn-auto-require"
      "middleclass"
      "mini-test"
      "neorg"
      "neotest"
      "nui-nvim"
      "nvim-cmp"
      "nvim-nio"
      "nvim-web-devicons"
      "oil-nvim"
      "orgmode"
      "papis-nvim"
      "rest-nvim"
      "rocks-config-nvim"
      "rtp-nvim"
      "telescope-manix"
      "telescope-nvim"
    ];
    toVimPackage =
      name:
      neovimUtils.buildNeovimPlugin {
        luaAttr = luaPackages.${name};
      };
  in
  lib.genAttrs luarocksPackageNames toVimPackage
)
// {

  rocks-nvim =
    (neovimUtils.buildNeovimPlugin {
      luaAttr = luaPackages.rocks-nvim;
    }).overrideAttrs
      (oa: {
        passthru = oa.passthru // {
          initLua = ''
            vim.g.rocks_nvim = {
              luarocks_binary = "${neovim-unwrapped.lua.pkgs.luarocks_bootstrap}/bin/luarocks"
              }
          '';
        };

      });
}
