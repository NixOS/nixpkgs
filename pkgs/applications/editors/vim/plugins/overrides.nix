{
  lib,
  stdenv,
  # nixpkgs functions
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  replaceVars,
  # Language dependencies
  fetchYarnDeps,
  mkYarnModules,
  python3,
  # Misc dependencies
  charm-freeze,
  code-minimap,
  dailies,
  dasht,
  deno,
  direnv,
  fzf,
  gawk,
  gperf,
  helm-ls,
  himalaya,
  htop,
  jq,
  khard,
  languagetool,
  libgit2,
  llvmPackages,
  neovim-unwrapped,
  nim1,
  nodejs,
  openscad,
  openssh,
  ranger,
  ripgrep,
  sqlite,
  sshfs,
  stylish-haskell,
  tabnine,
  tmux,
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
  # cornelis dependencies
  cornelis,
  # cpsm dependencies
  boost,
  cmake,
  icu,
  ncurses,
  # devdocs-nvim dependencies
  pandoc,
  # nvim-tinygit
  gitMinimal,
  # Preview-nvim dependencies
  md-tui,
  # sidekick-nvim dependencies
  copilot-language-server,
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
  aider-chat,
  # typst-preview dependencies
  tinymist,
  websocat,
  # lazydocker.nvim dependencies
  lazydocker,
  # lazyjj.nvim dependencies
  lazyjj,
  # luau-lsp-nvim dependencies
  luau-lsp,
  # uv.nvim dependencies
  uv,
  # nvim-vstsl dependencies
  vtsls,
  # search-and-replace.nvim dependencies
  fd,
  sad,
}:
self: super:
let
  luaPackages = neovim-unwrapped.lua.pkgs;

  # Ensures new attributes are not added in this file.
  assertNoAdditions =
    overrides:
    let
      prevNames = lib.attrNames super;
      definedNames = lib.attrNames overrides;
      addedNames = lib.subtractLists prevNames definedNames;
    in
    lib.throwIfNot (addedNames == [ ])
      "vimPlugins: the following attributes should not be defined in overrides.nix:${
        lib.concatMapStrings (name: "\n- ${name}") addedNames
      }"
      overrides;
in

assertNoAdditions {
  # keep-sorted start case=no block=yes newline_separated=yes
  advanced-git-search-nvim = super.advanced-git-search-nvim.overrideAttrs {
    checkInputs = with self; [
      fzf-lua
      snacks-nvim
      telescope-nvim
    ];
    dependencies = with self; [
      vim-fugitive
      vim-rhubarb
      plenary-nvim
    ];
  };

  aerial-nvim = super.aerial-nvim.overrideAttrs {
    # optional dependencies
    checkInputs = with self; [
      lualine-nvim
      telescope-nvim
      fzf-lua
    ];
  };

  agitator-nvim = super.agitator-nvim.overrideAttrs {
    dependencies = with self; [
      telescope-nvim
      plenary-nvim
    ];
  };

  aider-nvim = super.aider-nvim.overrideAttrs {
    patches = [
      (replaceVars ./patches/aider-nvim/bin.patch { aider = lib.getExe' aider-chat "aider"; })
    ];
  };

  animation-nvim = super.animation-nvim.overrideAttrs {
    dependencies = [ self.middleclass ];
  };

  arshlib-nvim = super.arshlib-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
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
    # Optional toggleterm integration
    checkInputs = [ self.toggleterm-nvim ];
  };

  autosave-nvim = super.autosave-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  auto-session = super.auto-session.overrideAttrs {
    # Optional integration
    checkInputs = [ self.telescope-nvim ];
  };

  aw-watcher-vim = super.aw-watcher-vim.overrideAttrs {
    patches = [
      (replaceVars ./patches/aw-watcher-vim/program_paths.patch {
        curl = lib.getExe curl;
      })
    ];
  };

  bamboo-nvim = super.bamboo-nvim.overrideAttrs {
    # Optional integration
    checkInputs = with self; [
      barbecue-nvim
      lualine-nvim
    ];
    nvimSkipModules = [
      # Requires config table
      "bamboo.colors"
      "bamboo.terminal"
      "bamboo.highlights"
      "bamboo-light"
      "bamboo-vulgaris"
      "bamboo-multiplex"
      "barbecue.theme.bamboo"
    ];
  };

  barbar-nvim = super.barbar-nvim.overrideAttrs {
    # Optional integrations
    checkInputs = with self; [
      bufferline-nvim
      nvim-web-devicons
    ];
    # E5108: Error executing lua ...implugin-barbar.nvim-2025-04-28/lua/bufferline/utils.lua:10: module 'barbar.utils.hl' not found:
    nvimSkipModules = [ "bufferline.utils" ];
  };

  barbecue-nvim = super.barbecue-nvim.overrideAttrs (old: {
    dependencies = with self; [
      nvim-lspconfig
      nvim-navic
    ];
    meta = old.meta // {
      description = "VS Code like winbar for Neovim";
      homepage = "https://github.com/utilyre/barbecue.nvim";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ lightquantum ];
    };
  });

  base46 = super.base46.overrideAttrs {
    dependencies = [ self.nvchad-ui ];
    # Requires global config setup
    nvimSkipModules = [
      "nvchad.configs.cmp"
      "nvchad.configs.gitsigns"
      "nvchad.configs.luasnip"
      "nvchad.configs.mason"
      "nvchad.configs.nvimtree"
      "nvchad.configs.telescope"
    ];
  };

  blink-cmp-copilot = super.blink-cmp-copilot.overrideAttrs {
    dependencies = [ self.copilot-lua ];
  };

  blink-cmp-dictionary = super.blink-cmp-dictionary.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  blink-cmp-git = super.blink-cmp-git.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  blink-cmp-npm-nvim = super.blink-cmp-npm-nvim.overrideAttrs {
    nvimSkipModules = [
      # Test files
      "blink-cmp-npm.utils.compute_meta_spec"
      "blink-cmp-npm.utils.generate_doc_spec"
      "blink-cmp-npm.utils.ignore_version_spec"
      "blink-cmp-npm.utils.is_cursor_in_dependencies_node_spec"
      "blink-cmp-npm.utils.semantic_sort_spec"
      "minit"
    ];
  };

  blink-emoji-nvim = super.blink-emoji-nvim.overrideAttrs {
    dependencies = [ self.blink-cmp ];
  };

  blink-nerdfont-nvim = super.blink-nerdfont-nvim.overrideAttrs {
    dependencies = [ self.blink-cmp ];
  };

  blink-cmp-words = super.blink-cmp-words.overrideAttrs (old: {
    dependencies = [ self.blink-cmp ];
    meta = old.meta // {
      description = "Offline word and synonym completion provider for Neovim";
      maintainers = with lib.maintainers; [ m3l6h ];
    };
  });

  blink-cmp-env = super.blink-cmp-env.overrideAttrs {
    dependencies = [ self.blink-cmp ];
  };

  blink-cmp-yanky = super.blink-cmp-yanky.overrideAttrs {
    dependencies = [ self.blink-cmp ];
  };

  bluloco-nvim = super.bluloco-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
  };

  bufferline-nvim = super.bufferline-nvim.overrideAttrs {
    # depends on bufferline.lua being loaded first
    nvimSkipModules = [ "bufferline.commands" ];
  };

  bufresize-nvim = super.bufresize-nvim.overrideAttrs (old: {
    meta = old.meta // {
      license = lib.licenses.mit;
    };
  });

  catppuccin-nvim = super.catppuccin-nvim.overrideAttrs {
    nvimSkipModules = [
      "catppuccin.groups.integrations.noice"
      "catppuccin.groups.integrations.feline"
      "catppuccin.lib.vim.init"
    ];
  };

  ccc-nvim = super.ccc-nvim.overrideAttrs {
    # ccc auto-discover requires all pass
    # but there's a bootstrap module that hangs forever if we dont stop on first success
    nvimSkipModules = [ "ccc.kit.Thread.Server._bootstrap" ];
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

  checkmate-nvim = super.checkmate-nvim.overrideAttrs {
    checkInputs = with self; [
      # checkmate.snippets
      luasnip
    ];
  };

  clang_complete = super.clang_complete.overrideAttrs {
    # In addition to the arguments you pass to your compiler, you also need to
    # specify the path of the C++ std header (if you are using C++).
    # These usually implicitly set by cc-wrapper around clang (pkgs/build-support/cc-wrapper).
    # The linked ruby code shows generates the required '.clang_complete' for cmake based projects
    # https://gist.github.com/Mic92/135e83803ed29162817fce4098dec144
    preFixup = ''
      substituteInPlace "$out"/plugin/clang_complete.vim \
        --replace-fail "let g:clang_library_path = ''
    + "''"
    + ''
      " "let g:clang_library_path='${lib.getLib llvmPackages.libclang}/lib/libclang.so'"

            substituteInPlace "$out"/plugin/libclang.py \
              --replace-fail "/usr/lib/clang" "${llvmPackages.clang.cc}/lib/clang"
    '';
  };

  claude-code-nvim = super.claude-code-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
    ];
  };

  claude-fzf-nvim = super.claude-fzf-nvim.overrideAttrs {
    dependencies = with self; [
      claudecode-nvim
      fzf-lua
    ];
    # Failed to build help tags!
    # E670: Mix of help file encodings within a language: doc/claude-fzf-zh.txt
    # E154: Duplicate tag "claude-fzf-keymaps" in file doc/claude-fzf-en.txt
    preInstall = ''
      rm -r doc
    '';
  };

  claude-fzf-history-nvim = super.claude-fzf-history-nvim.overrideAttrs {
    dependencies = with self; [
      fzf-lua
    ];
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
    nvimSkipModules = [
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

  cmp-dotenv = super.cmp-dotenv.overrideAttrs {
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

  cmp-vimtex = super.cmp-vimtex.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-vimwiki-tags = super.cmp-vimwiki-tags.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ self.vimwiki ];
  };

  cmp-vsnip = super.cmp-vsnip.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
  };

  cmp-zsh = super.cmp-zsh.overrideAttrs {
    checkInputs = [ self.nvim-cmp ];
    dependencies = [ zsh ];
  };

  cobalt2-nvim = super.cobalt2-nvim.overrideAttrs {
    dependencies = with self; [ colorbuddy-nvim ];
    # Few broken themes
    nvimSkipModules = [
      "cobalt2.plugins.init"
      "cobalt2.plugins.trouble"
      "cobalt2.plugins.gitsigns"
      "cobalt2.plugins.package-info"
      "cobalt2.plugins.indent-blankline"
      "cobalt2.plugins.marks"
      "cobalt2.theme"
    ];
  };

  codecompanion-nvim = super.codecompanion-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional completion
      blink-cmp
      nvim-cmp
      # Optional pickers
      fzf-lua
      mini-nvim
      snacks-nvim
      telescope-nvim
    ];
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
      # Requires setup call
      "codecompanion.actions.static"
      "codecompanion.actions.init"
      # Address in use error from fzf-lua on darwin
      # https://github.com/NixOS/nixpkgs/issues/431458
      "codecompanion.providers.actions.fzf_lua"
      # Test
      "minimal"
    ];
  };

  codecompanion-history-nvim = super.codecompanion-history-nvim.overrideAttrs {
    dependencies = with self; [
      # transitive dependency for codecompanion-nvim
      plenary-nvim

      codecompanion-nvim
    ];
  };

  windsurf-nvim =
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
    super.windsurf-nvim.overrideAttrs {
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

  codewindow-nvim = super.codewindow-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  colorful-menu-nvim = super.colorful-menu-nvim.overrideAttrs {
    # Local bug reproduction modules
    nvimSkipModules = [
      "repro_blink"
      "repro_cmp"
    ];
  };

  command-t = super.command-t.overrideAttrs {
    nativeBuildInputs = [
      getconf
    ];
    buildPhase = ''
      substituteInPlace lua/wincent/commandt/lib/Makefile \
        --replace-fail '/bin/bash' 'bash' \
        --replace-fail xcrun ""
      make build
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
    nvimSkipModules = [
      # Test mismatch of directory because of nix generated path
      "conjure-spec.client.common-lisp.swank_spec"
      "conjure-spec.client.fennel.nfnl_spec"
      "conjure-spec.client.guile.socket_spec"
      "conjure-spec.client.scheme.stdio_spec"
      # No parser for fennel
      "conjure.client.fennel.def-str-util"
    ];
  };

  context-vim = super.context-vim.overrideAttrs {
    # Vim plugin with optional lua highlight module
    nvimSkipModules = [ "context.highlight" ];
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

  cpsm = super.cpsm.overrideAttrs (old: {
    # CMake 4 dropped support of versions lower than 3.5, and versions
    # lower than 3.10 are deprecated.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          "cmake_minimum_required(VERSION 2.8.12)" \
          "cmake_minimum_required(VERSION 3.10)"
    '';
    nativeBuildInputs = [ cmake ];
    buildInputs = [
      python3
      boost
      icu
      ncurses
    ];
    buildPhase = ''
      runHook preBuild

      patchShebangs .
      export PY3=ON
      ./install.sh

      runHook postBuild
    '';
  });

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

  dailies-nvim = super.dailies-nvim.overrideAttrs {
    runtimeDeps = [
      dailies
    ];
  };

  darkearth-nvim = super.darkearth-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
    # Lua module used to build theme
    nvimSkipModules = [ "shipwright_build" ];
  };

  ddc-filter-matcher_head = super.ddc-filter-matcher_head.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-filter-sorter_rank = super.ddc-filter-sorter_rank.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-fuzzy = super.ddc-fuzzy.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-source-around = super.ddc-source-around.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-source-file = super.ddc-source-file.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-source-lsp = super.ddc-source-lsp.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-ui-pum = super.ddc-ui-pum.overrideAttrs {
    dependencies = with self; [
      ddc-vim
      pum-vim
    ];
  };

  ddc-ui-native = super.ddc-ui-native.overrideAttrs {
    dependencies = [ self.ddc-vim ];
  };

  ddc-vim = super.ddc-vim.overrideAttrs {
    dependencies = [ self.denops-vim ];
  };

  debugmaster-nvim = super.debugmaster-nvim.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  defx-nvim = super.defx-nvim.overrideAttrs {
    dependencies = [ self.nvim-yarp ];
  };

  demicolon-nvim = super.demicolon-nvim.overrideAttrs (old: {
    dependencies = with self; [
      nvim-treesitter
      nvim-treesitter-textobjects
    ];
    meta = old.meta // {
      description = "Overloaded ; and , keys in Neovim";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ m3l6h ];
    };
  });

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

  deoplete-khard = super.deoplete-khard.overrideAttrs (old: {
    dependencies = [ self.deoplete-nvim ];
    passthru.python3Dependencies = ps: [ (ps.toPythonModule khard) ];
    meta = old.meta // {
      description = "Address-completion for khard via deoplete";
      homepage = "https://github.com/nicoe/deoplete-khard";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ jorsn ];
    };
  });

  devdocs-nvim = super.devdocs-nvim.overrideAttrs {
    nvimSkipModules = [
      # Error initializing Devdocs state
      "devdocs.state"
    ];
    runtimeDeps = [
      curl
      jq
      pandoc
    ];
  };

  diagram-nvim = super.diagram-nvim.overrideAttrs {
    dependencies = [ self.image-nvim ];
  };

  diffview-nvim = super.diffview-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];

    nvimSkipModules = [
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
    preFixup = old.preFixup or "" + ''
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
    nvimSkipModules = [ "dropbar.menu" ];
  };

  easy-dotnet-nvim = super.easy-dotnet-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
    ];
    checkInputs = with self; [
      # Pickers, can use telescope, fzf-lua, or snacks
      fzf-lua
      telescope-nvim
    ];
  };

  ecolog-nvim = super.ecolog-nvim.overrideAttrs {
    nvimSkipModules = [
      "repro"
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
    nvimSkipModules = [
      # E5108: Error executing lua vim/_init_packages.lua:0: ...in-faust-nvim-2022-06-01/lua/faust-nvim/autosnippets.lua:3: '=' expected near 'wd'
      "faust-nvim.autosnippets"
    ];
  };

  fcitx-vim = super.fcitx-vim.overrideAttrs (old: {
    passthru.python3Dependencies = ps: with ps; [ dbus-python ];
    meta = old.meta // {
      description = "Keep and restore fcitx state when leaving/re-entering insert mode or search mode";
      license = lib.licenses.mit;
    };
  });

  flash-nvim = super.flash-nvim.overrideAttrs {
    # Docs require lazyvim
    # dependencies = with self; [ lazy-nvim ];
    nvimSkipModules = [ "flash.docs" ];
  };

  flit-nvim = super.flit-nvim.overrideAttrs {
    dependencies = [ self.leap-nvim ];
  };

  floaterm = super.floaterm.overrideAttrs {
    dependencies = [ self.nvzone-volt ];
  };

  flutter-tools-nvim = super.flutter-tools-nvim.overrideAttrs {
    # Optional dap integration
    checkInputs = [ self.nvim-dap ];
    dependencies = [ self.plenary-nvim ];
  };

  follow-md-links-nvim = super.follow-md-links-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  forms = super.forms.overrideAttrs {
    dependencies = [ self.self ];
  };

  freeze-nvim = super.freeze-nvim.overrideAttrs {
    runtimeDeps = [ charm-freeze ];
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
      substituteInPlace lua/fugit2/core/libgit2.lua \
        --replace-fail \
        'M.library_path = "libgit2"' \
        'M.library_path = "${lib.getLib libgit2}/lib/libgit2${stdenv.hostPlatform.extensions.sharedLibrary}"'
    '';
  };

  fuzzy-nvim = super.fuzzy-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional sorters
      telescope-zf-native-nvim
    ];
    dependencies = [ self.telescope-fzf-native-nvim ];
    nvimSkipModules = [
      # TODO: package fzy-lua-native
      "fuzzy_nvim.fzy_matcher"
    ];
  };

  fyler-nvim = super.fyler-nvim.overrideAttrs {
    nvimSkipModules = [
      # Requires setup call
      "fyler.views.explorer.init"
      "fyler.views.explorer.actions"
      "fyler.views.explorer.ui"
      "fyler.explorer.ui"
      "fyler.explorer"
    ];
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

  fzf-lua = super.fzf-lua.overrideAttrs {
    runtimeDeps = [ fzf ];
    nvimSkipModules = [
      "fzf-lua.shell_helper"
      "fzf-lua.spawn"
      "fzf-lua.rpc"
      "fzf-lua.types"
    ];
  };

  fzf-vim = super.fzf-vim.overrideAttrs {
    dependencies = [ self.fzf-wrapper ];
  };

  gen-nvim = super.gen-nvim.overrideAttrs {
    runtimeDeps = [ curl ];
  };

  ghcid = super.ghcid.overrideAttrs {
    configurePhase = "cd plugins/nvim";
  };

  gh-nvim = super.gh-nvim.overrideAttrs {
    dependencies = [ self.litee-nvim ];
  };

  gitlinker-nvim = super.gitlinker-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
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

  git-worktree-nvim = super.git-worktree-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  go-nvim = super.go-nvim.overrideAttrs {
    checkInputs = with self; [
      luasnip
      null-ls-nvim
      nvim-treesitter
    ];
    nvimSkipModules = [
      # _GO_NVIM_CFG
      "go.inlay"
      "go.project"
      "go.comment"
      "go.tags"
      "go.gotests"
      "go.format"
      "go.ts.go"
      "go.ts.nodes"
      "go.snips"
      "snips.go"
    ];
  };

  GPTModels-nvim = super.GPTModels-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      telescope-nvim
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

    nvimSkipModules = [
      # Cannot find hardhat.extmarks
      "overseer.component.hardhat.refresh_gas_extmarks"
    ];
  };

  harpoon = super.harpoon.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  harpoon2 = super.harpoon2.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
      # Access harpoon data file
      "harpoon.scratch.toggle"
    ];
  };

  haskell-scope-highlighting-nvim = super.haskell-scope-highlighting-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  haskell-snippets-nvim = super.haskell-snippets-nvim.overrideAttrs {
    dependencies = [ self.luasnip ];
  };

  haskell-tools-nvim = super.haskell-tools-nvim.overrideAttrs {
    # Optional integrations
    checkInputs = [ self.telescope-nvim ];
  };

  helm-ls-nvim = super.helm-ls-nvim.overrideAttrs {
    runtimeDeps = [
      helm-ls
    ];
  };

  helpview-nvim = super.helpview-nvim.overrideAttrs {
    nvimSkipModules = [ "definitions.__vimdoc" ];
  };

  hex-nvim = super.hex-nvim.overrideAttrs {
    runtimeDeps = [ xxd ];
  };

  himalaya-vim = super.himalaya-vim.overrideAttrs {
    buildInputs = [ himalaya ];
    # Optional integrations
    checkInputs = with self; [
      fzf-lua
      telescope-nvim
    ];
  };

  hover-nvim = super.hover-nvim.overrideAttrs {
    # Single provider issue with reading from config
    # /lua/hover/providers/fold_preview.lua:27: attempt to index local 'config' (a nil value)
    nvimSkipModules = "hover.providers.fold_preview";
  };

  hunk-nvim = super.hunk-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  hurl-nvim = super.hurl-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      nvim-treesitter
      plenary-nvim
    ];

    runtimeDeps = [
      hurl
    ];

    nvimSkipModules = [
      # attempt to index global '_HURL_GLOBAL_CONFIG' (a nil value)
      "hurl.popup"
      "hurl.split"
    ];
  };

  idris2-nvim = super.idris2-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      nvim-lspconfig
    ];

    doInstallCheck = true;
  };

  indent-blankline-nvim = super.indent-blankline-nvim.overrideAttrs {
    # Meta file
    nvimSkipModules = "ibl.config.types";
  };

  indent-tools-nvim = super.indent-tools-nvim.overrideAttrs {
    dependencies = with self; [
      arshlib-nvim
      nvim-treesitter
      nvim-treesitter-textobjects
    ];
  };

  instant-nvim = super.instant-nvim.overrideAttrs {
    nvimSkipModules = [
      # Requires global variable config
      "instant"
      # instant/log.lua:12: cannot use '...' outside a vararg function near '...'
      "instant.log"
    ];
  };

  intellitab-nvim = super.intellitab-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  jdd-nvim = super.jdd-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  jedi-vim = super.jedi-vim.overrideAttrs (old: {
    # checking for python3 support in vim would be neat, too, but nobody else seems to care
    buildInputs = [ python3.pkgs.jedi ];
    meta = old.meta // {
      description = "code-completion for python using python-jedi";
      license = lib.licenses.mit;
    };
  });

  jellybeans-nvim = super.jellybeans-nvim.overrideAttrs {
    dependencies = [ self.lush-nvim ];
  };

  jupytext-nvim = super.jupytext-nvim.overrideAttrs {
    passthru.python3Dependencies = ps: [ ps.jupytext ];
  };

  kanagawa-paper-nvim = super.kanagawa-paper-nvim.overrideAttrs {
    nvimSkipModules = [
      # skipping wezterm theme switcher since it relies on a wezterm module
      # that does not seem to be available, tried to build setting wezterm-nvim as a dep
      "wezterm.theme_switcher"
    ];
  };

  kulala-nvim = super.kulala-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      nvim-treesitter-parsers.http
    ];
    buildInputs = [ curl ];
    postPatch = ''
      substituteInPlace lua/kulala/config/defaults.lua \
        --replace-fail 'curl_path = "curl"' 'curl_path = "${lib.getExe curl}"'
    '';
    nvimSkipModules = [
      # Requires some extra work to get CLI working in nixpkgs
      "cli.kulala_cli"
    ];
  };

  lazydocker-nvim = super.lazydocker-nvim.overrideAttrs {
    runtimeDeps = [
      lazydocker
    ];
  };

  lazyjj-nvim = super.lazyjj-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    runtimeDeps = [
      lazyjj
    ];
  };

  LazyVim = super.LazyVim.overrideAttrs {
    # Any other dependency is optional
    dependencies = [ self.lazy-nvim ];
    nvimSkipModules = [
      # attempt to index global 'LazyVim' (a nil value)
      "lazyvim.config.keymaps"
      "lazyvim.plugins.extras.ai.copilot-native"
      "lazyvim.plugins.extras.ai.sidekick"
      "lazyvim.plugins.extras.ai.tabnine"
      "lazyvim.plugins.extras.coding.blink"
      "lazyvim.plugins.extras.coding.luasnip"
      "lazyvim.plugins.extras.coding.neogen"
      "lazyvim.plugins.extras.editor.fzf"
      "lazyvim.plugins.extras.editor.snacks_picker"
      "lazyvim.plugins.extras.editor.telescope"
      "lazyvim.plugins.extras.formatting.prettier"
      "lazyvim.plugins.extras.lang.dotnet"
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
    nvimSkipModules = [
      # Requires headless config option
      "lazy.manage.task.init"
      "lazy.manage.checker"
      "lazy.manage.init"
      "lazy.manage.runner"
      "lazy.view.commands"
      "lazy.build"
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

  lean-nvim = super.lean-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-lspconfig
      plenary-nvim
    ];
  };

  leap-ast-nvim = super.leap-ast-nvim.overrideAttrs {
    dependencies = with self; [
      leap-nvim
      nvim-treesitter
    ];
  };

  leetcode-nvim = super.leetcode-nvim.overrideAttrs {
    checkInputs = with self; [
      snacks-nvim
      telescope-nvim
      mini-nvim
    ];
    dependencies = with self; [
      nui-nvim
      plenary-nvim
    ];

    doInstallCheck = true;
    nvimSkipModules = [
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
      "leetcode.picker.question.snacks"
      "leetcode.picker.question.telescope"
      "leetcode.picker.question.mini"
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
    nvimSkipModules = [
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

  lf-nvim = super.lf-nvim.overrideAttrs {
    dependencies = [ self.toggleterm-nvim ];
  };

  lf-vim = super.lf-vim.overrideAttrs {
    dependencies = [ self.vim-floaterm ];
  };

  lightline-bufferline = super.lightline-bufferline.overrideAttrs {
    # Requires web-devicons but mini.icons can mock them up
    checkInputs = [ self.nvim-web-devicons ];
  };

  lightswitch-nvim = super.lightswitch-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
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
    nvimSkipModules = [
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

  live-preview-nvim = super.live-preview-nvim.overrideAttrs (old: {
    checkInputs = with self; [
      fzf-lua
      mini-pick
      snacks-nvim
      telescope-nvim
    ];

    nvimSkipModules = [
      # Ignore livepreview._spec as it fails nvimRequireCheck.
      # This file runs tests on require which unfortunately fails as it attempts to require the base plugin. See https://github.com/brianhuster/live-preview.nvim/blob/5890c4f7cb81a432fd5f3b960167757f1b4d4702/lua/livepreview/_spec.lua#L25
      "livepreview._spec"
    ];
    meta = old.meta // {
      license = lib.licenses.gpl3Only;
    };
  });

  lspcontainers-nvim = super.lspcontainers-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  lspecho-nvim = super.lspecho-nvim.overrideAttrs (old: {
    meta = old.meta // {
      license = lib.licenses.mit;
    };
  });

  lspsaga-nvim = super.lspsaga-nvim.overrideAttrs {
    # Other modules require setup call first
    nvimRequireCheck = "lspsaga";
  };

  lsp_extensions-nvim = super.lsp_extensions-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  ltex_extra-nvim = super.ltex_extra-nvim.overrideAttrs {
    # Other modules require setup call first
    nvimRequireCheck = "ltex_extra";
  };

  lualine-lsp-progress = super.lualine-lsp-progress.overrideAttrs {
    dependencies = [ self.lualine-nvim ];
  };

  luasnip-latex-snippets-nvim = super.luasnip-latex-snippets-nvim.overrideAttrs {
    dependencies = [ self.luasnip ];
    # E5108: /luasnip-latex-snippets/luasnippets/tex/utils/init.lua:3: module 'luasnip-latex-snippets.luasnippets.utils.conditions' not found:
    # Need to fix upstream
    nvimSkipModules = [
      "luasnip-latex-snippets.luasnippets.tex.utils.init"
    ];
  };

  LuaSnip-snippets-nvim = super.LuaSnip-snippets-nvim.overrideAttrs {
    checkInputs = [ self.luasnip ];
  };

  luau-lsp-nvim = super.luau-lsp-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    runtimeDeps = [ luau-lsp ];
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

  maple-nvim = super.maple-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  markdoc-nvim = super.markdoc-nvim.overrideAttrs {
    dependencies = with self; [
      (nvim-treesitter.withPlugins (p: [
        p.markdown
        p.markdown_inline
        p.html
      ]))
    ];
  };

  markdown-preview-nvim =
    let
      # We only need its dependencies `node-modules`.
      nodeDep = mkYarnModules rec {
        inherit (super.markdown-preview-nvim) pname version;
        packageJSON = ./patches/markdown-preview-nvim/package.json;
        yarnLock = "${super.markdown-preview-nvim.src}/yarn.lock";
        offlineCache = fetchYarnDeps {
          inherit yarnLock;
          hash = "sha256-kzc9jm6d9PJ07yiWfIOwqxOTAAydTpaLXVK6sEWM8gg=";
        };
      };
    in
    super.markdown-preview-nvim.overrideAttrs {
      patches = [
        (replaceVars ./patches/markdown-preview-nvim/fix-node-paths.patch {
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
    nvimSkipModules = [
      # lua/mason-vendor/zzlib/inflate-bwo.lua:15: 'end' expected near '&'
      "mason-vendor.zzlib.inflate-bwo"
      # E5108: Error executing lua ...mplugin-mason.nvim-2025-05-06/lua/mason-test/helpers.lua:7: module 'luassert.spy' not found:
      "mason-test.helpers"
    ];
  };

  mason-tool-installer-nvim = super.mason-tool-installer-nvim.overrideAttrs {
    dependencies = [ self.mason-nvim ];
  };

  material-vim = super.material-vim.overrideAttrs {
    # Optional integration
    checkInputs = [ self.lualine-nvim ];
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

  minuet-ai-nvim = super.minuet-ai-nvim.overrideAttrs {
    checkInputs = [
      # optional cmp integration
      self.nvim-cmp
      self.lualine-nvim
    ];
    dependencies = with self; [ plenary-nvim ];
    nvimSkipModules = [
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
    nvimSkipModules = "modicator.integration.lualine.init";
  };

  molten-nvim = super.molten-nvim.overrideAttrs {
    # Optional image providers
    checkInputs = with self; [
      image-nvim
      snacks-nvim
      wezterm-nvim
    ];
  };

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
    # Optional diffview integration
    checkInputs = [ self.diffview-nvim ];
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
      # E5108: Error executing lua ...vim-2024-06-13/lua/diffview/api/views/diff/diff_view.lua:13: attempt to index global 'DiffviewGlobal' (a nil value)
      "neogit.integrations.diffview"
      "neogit.popups.diff.actions"
      "neogit.popups.diff.init"
    ];
  };

  neorepl-nvim = super.neorepl-nvim.overrideAttrs {
    nvimSkipModules = [
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

  neotest-bash = super.neotest-bash.overrideAttrs {
    dependencies = with self; [
      neotest
      plenary-nvim
    ];
  };

  neotest-ctest = super.neotest-ctest.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
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
    nvimSkipModules = [
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
    nvimSkipModules = "neotest-jest-assertions";
  };

  neotest-mocha = super.neotest-mocha.overrideAttrs {
    dependencies = with self; [
      neotest
      nvim-nio
      nvim-treesitter
      plenary-nvim
    ];
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
    checkInputs = with self; [
      # Optional picker integration
      telescope-nvim
    ];
    dependencies = with self; [
      neotest
      nvim-nio
      plenary-nvim
    ];
    # Unit test assert
    nvimSkipModules = "neotest-playwright-assertions";
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
    nvimSkipModules = "neotest-vitest-assertions";
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
    nvimSkipModule = [
      "neo-tree.types.fixes.compat-0.10"
    ];
  };

  netman-nvim = super.netman-nvim.overrideAttrs {
    # Optional neo-tree integration
    checkInputs = with self; [
      neo-tree-nvim
      # FIXME: propagate `neo-tree` dependencies
      nui-nvim
      plenary-nvim
    ];
  };

  neovim-trunk = super.neovim-trunk.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      telescope-nvim
    ];
  };

  neovim-tips = super.neovim-tips.overrideAttrs {
    dependencies = [
      self.nui-nvim
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
      nvchad-ui
    ];
    nvimSkipModules = [
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
    nvimSkipModules = [
      # Requires global config setup
      "nvchad.tabufline.modules"
      "nvchad.term.init"
      "nvchad.themes.init"
      "nvchad.themes.mappings"
      "nvchad.cheatsheet.grid"
      "nvchad.cheatsheet.simple"
      "nvchad.blink.config"
      # Circular dependency with base46
      "nvchad.utils"
    ];
  };

  nvim-autopairs = super.nvim-autopairs.overrideAttrs {
    # Optional completion dependency
    checkInputs = with self; [
      nvim-cmp
    ];
    nvimSkipModules = [
      # compe not packaged anymore
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

  nvim-coverage = super.nvim-coverage.overrideAttrs {
    dependencies = with self; [
      neotest
      plenary-nvim
    ];
    nvimSkipModules = [
      # TODO: Add lua-xmlreader package
      "coverage.parsers.corbertura"
    ];
  };

  nvim-dap-cortex-debug = super.nvim-dap-cortex-debug.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dap-vscode-js = super.nvim-dap-vscode-js.overrideAttrs {
    dependencies = [ self.nvim-dap ];
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

  nvim-dap-view = super.nvim-dap-view.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-dap-virtual-text = super.nvim-dap-virtual-text.overrideAttrs {
    dependencies = [ self.nvim-dap ];
  };

  nvim-FeMaco-lua = super.nvim-FeMaco-lua.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-fzf-commands = super.nvim-fzf-commands.overrideAttrs {
    dependencies = [ self.nvim-fzf ];
    # Requires global variable setup nvim_fzf_directory
    nvimSkipModules = "fzf-commands.rg";
  };

  nvim-genghis = super.nvim-genghis.overrideAttrs {
    dependencies = [ self.dressing-nvim ];

    doInstallCheck = true;
  };

  nvim-gps = super.nvim-gps.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-highlight-colors = super.nvim-highlight-colors.overrideAttrs {
    # Test module
    nvimSkipModules = [
      "nvim-highlight-colors.utils_spec"
      "nvim-highlight-colors.buffer_utils_spec"
      "nvim-highlight-colors.color.converters_spec"
      "nvim-highlight-colors.color.patterns_spec"
      "nvim-highlight-colors.color.utils_spec"
    ];
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
    nvimSkipModules = [
      # Requires the `java.utils.ui` module which seems to be provided by `nvim-java` (cyclic dependency)
      # -> Skip to avoid infinite recursion
      "java-refactor.action"
      "java-refactor.refactor"
    ];
  };

  nvim-java-test = super.nvim-java-test.overrideAttrs {
    dependencies = [ self.nvim-java-core ];
  };

  nvim-lilypond-suite = super.nvim-lilypond-suite.overrideAttrs {
    nvimSkipModule = [
      # Option not set immediately
      "nvls.errors.lilypond-book"
      "nvls.tex"
      "nvls.texinfo"
    ];
  };

  nvim-k8s-crd = super.nvim-k8s-crd.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      nvim-lspconfig
    ];
  };

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
    nvimSkipModules = [ "moonwalk" ];
  };

  nvim-navbuddy = super.nvim-navbuddy.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      nvim-lspconfig
      nvim-navic
    ];
  };
  nvim-navic = super.nvim-navic.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
  };

  nvim-neoclip-lua = super.nvim-neoclip-lua.overrideAttrs {
    # Optional dependencies
    checkInputs = with self; [
      fzf-lua
      telescope-nvim
    ];
  };

  nvim-nonicons = super.nvim-nonicons.overrideAttrs {
    # Requires web-devicons but mini.icons can mock them up
    checkInputs = [ self.nvim-web-devicons ];
  };

  nvim-notify = super.nvim-notify.overrideAttrs {
    # Optional fzf integration
    checkInputs = [
      self.fzf-lua
    ];

    nvimSkipModules = lib.optionals stdenv.hostPlatform.isDarwin [
      #FIXME: https://github.com/NixOS/nixpkgs/issues/431458
      # fzf-lua throws `address already in use` on darwin
      "notify.integrations.fzf"
    ];
  };

  nvim-nu = super.nvim-nu.overrideAttrs {
    dependencies = with self; [
      nvim-treesitter
      none-ls-nvim
    ];
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
    checkInputs = [
      # Optional cmp integration
      self.nvim-cmp
    ];
  };

  nvim-surround = super.nvim-surround.overrideAttrs {
    checkInputs = [
      # Optional treesitter integration
      self.nvim-treesitter
    ];
  };

  nvim-teal-maker = super.nvim-teal-maker.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/tealmaker/init.lua \
        --replace-fail cyan ${luaPackages.cyan}/bin/cyan
    '';
    vimCommandCheck = "TealBuild";
  };

  nvim-test = super.nvim-test.overrideAttrs {
    # Optional toggleterm integration
    checkInputs = [ self.toggleterm-nvim ];
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
    nvimSkipModules = [
      # Broken runners
      "nvim-test.runners.zig"
      "nvim-test.runners.hspec"
      "nvim-test.runners.stack"
    ];
  };

  nvim-tinygit = super.nvim-tinygit.overrideAttrs {
    checkInputs = [
      gitMinimal
      # interactive staging support
      self.telescope-nvim
    ];
  };

  nvim-tree-lua = super.nvim-tree-lua.overrideAttrs {
    nvimSkipModules = [
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
    nvimSkipModules = [ "install_parsers" ];
  };

  nvim-treesitter-endwise = super.nvim-treesitter-endwise.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  nvim-treesitter-pairs = super.nvim-treesitter-pairs.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

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

  nvim-ufo = super.nvim-ufo.overrideAttrs {
    dependencies = [ self.promise-async ];
  };

  nvim-unception = super.nvim-unception.overrideAttrs {
    # Attempt rpc socket connection
    nvimSkipModules = [
      "client.client"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "server.server"
      "unception"
    ];
  };

  nvim-vtsls = super.nvim-vtsls.overrideAttrs {
    runtimeDeps = [ vtsls ];
    dependencies = [ self.nvim-lspconfig ];
  };

  nvzone-menu = super.nvzone-menu.overrideAttrs {
    # Plugin managers like Lazy.nvim expect pname to match the name of the git repository
    pname = "menu";
    checkInputs = with self; [
      # Optional integrations
      nvim-tree-lua
      neo-tree-nvim
      # FIXME: should propagate from neo-tree-nvim
      nui-nvim
      plenary-nvim
    ];
    dependencies = [ self.nvzone-volt ];
  };

  nvzone-minty = super.nvzone-minty.overrideAttrs {
    # Plugin managers like Lazy.nvim expect pname to match the name of the git repository
    pname = "minty";
    dependencies = [ self.nvzone-volt ];
  };

  nvzone-typr = super.nvzone-typr.overrideAttrs {
    # Plugin managers like Lazy.nvim expect pname to match the name of the git repository
    pname = "typr";
    dependencies = [ self.nvzone-volt ];
  };

  nvzone-volt = super.nvzone-volt.overrideAttrs {
    # Plugin managers like Lazy.nvim expect pname to match the name of the git repository
    pname = "volt";
  };

  obsidian-nvim = super.obsidian-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional pickers
      fzf-lua
      mini-nvim
      snacks-nvim
      telescope-nvim
    ];
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
      # Issue reproduction file
      "minimal"
    ];
  };

  octo-nvim = super.octo-nvim.overrideAttrs {
    checkInputs = with self; [
      # Pickers, can use telescope or fzf-lua
      fzf-lua
      telescope-nvim
      snacks-nvim
    ];
    dependencies = with self; [
      plenary-nvim
    ];
  };

  oil-git-nvim = super.oil-git-nvim.overrideAttrs {
    dependencies = [ self.oil-nvim ];
  };

  oil-git-status-nvim = super.oil-git-status-nvim.overrideAttrs {
    dependencies = [ self.oil-nvim ];
  };

  ollama-nvim = super.ollama-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  omni-vim = super.omni-vim.overrideAttrs {
    # Optional lightline integration
    nvimSkipModules = "omni-lightline";
  };

  onedark-nvim = super.onedark-nvim.overrideAttrs {
    nvimSkipModules = [
      # Requires global config value
      "barbecue.theme.onedark"
      "onedark.highlights"
      "onedark.colors"
      "onedark.terminal"
    ];
  };

  onehalf = super.onehalf.overrideAttrs {
    configurePhase = "cd vim";
  };

  one-nvim = super.one-nvim.overrideAttrs (old: {
    # E5108: /lua/one-nvim.lua:14: Unknown option 't_Co'
    # https://github.com/Th3Whit3Wolf/one-nvim/issues/23
    meta = old.meta // {
      broken = true;
    };
  });

  # The plugin depends on either skim-vim or fzf-vim, but we don't want to force the user so we
  # avoid choosing one of them and leave it to the user
  openscad-nvim = super.openscad-nvim.overrideAttrs {
    buildInputs = [
      zathura
      htop
      openscad
    ];

    # FIXME: can't find plugin root dir
    nvimSkipModules = [
      "openscad"
      "openscad.snippets.openscad"
      "openscad.utilities"
    ];
    patches = [
      (replaceVars ./patches/openscad.nvim/program_paths.patch {
        htop = lib.getExe htop;
        openscad = lib.getExe openscad;
      })
    ];
  };

  org-roam-nvim = super.org-roam-nvim.overrideAttrs {
    dependencies = [ self.orgmode ];
  };

  otter-nvim = super.otter-nvim.overrideAttrs {
    dependencies = [ self.nvim-lspconfig ];
    nvimSkipModules = [
      # requires config setup
      "otter.keeper"
      "otter.lsp.handlers"
      "otter.lsp.init"
      "otter.diagnostics"
    ];
  };

  outline-nvim = super.outline-nvim.overrideAttrs {
    # Requires setup call
    nvimSkipModules = "outline.providers.norg";
  };

  overseer-nvim = super.overseer-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional integration
      neotest
      toggleterm-nvim
      nvim-dap
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
  };

  package-info-nvim = super.package-info-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  parpar-nvim = super.parpar-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-parinfer
      nvim-paredit
      nvim-treesitter
    ];
  };

  parrot-nvim = super.parrot-nvim.overrideAttrs {
    runtimeDeps = [
      curl
    ];

    dependencies = with self; [
      plenary-nvim
    ];

    checkInputs = [
      curl
      ripgrep
      # Optional integrations
      self.blink-cmp
      self.nvim-cmp
    ];
  };

  peek-nvim = super.peek-nvim.overrideAttrs (old: {
    patches = [
      # Patch peek-nvim to run using nixpkgs deno
      # This means end-users have to build peek-nvim the first time they use it...
      (replaceVars ./patches/peek-nvim/cmd.patch {
        deno = lib.getExe deno;
      })
    ];
  });

  persisted-nvim = super.persisted-nvim.overrideAttrs {
    nvimSkipModules = [
      # /lua/persisted/init.lua:44: attempt to index upvalue 'config' (a nil value)
      # https://github.com/olimorris/persisted.nvim/issues/146
      "persisted"
      "persisted.config"
      "persisted.utils"
    ];
  };

  persistent-breakpoints-nvim = super.persistent-breakpoints-nvim.overrideAttrs {
    dependencies = with self; [
      nvim-dap
    ];
  };

  plantuml-nvim = super.plantuml-nvim.overrideAttrs {
    dependencies = [ self.LibDeflate-nvim ];
  };

  playground = super.playground.overrideAttrs {
    dependencies = with self; [
      # we need the 'query' grammar to make
      (nvim-treesitter.withPlugins (p: [ p.query ]))
    ];
  };

  poimandres-nvim = super.poimandres-nvim.overrideAttrs {
    # Optional treesitter support
    nvimSkipModules = "poimandres.highlights";
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

  project-nvim = super.project-nvim.overrideAttrs {
    checkInputs = [
      # Optional telescope integration
      self.telescope-nvim
    ];
  };

  python-mode = super.python-mode.overrideAttrs {
    postPatch = ''
      # NOTE: Fix broken symlink - the pytoolconfig directory was moved to src/
      # https://github.com/python-mode/python-mode/pull/1189#issuecomment-3109528360
      rm -f pymode/libs/pytoolconfig
      ln -sf ../../submodules/pytoolconfig/src/pytoolconfig pymode/libs/pytoolconfig
    '';
  };

  pywal-nvim = super.pywal-nvim.overrideAttrs {
    # Optional feline integration
    nvimSkipModules = "pywal.feline";
  };

  qmk-nvim = super.qmk-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
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

  quarto-nvim = super.quarto-nvim.overrideAttrs {
    checkInputs = [
      # Optional runner
      self.iron-nvim
    ];
    dependencies = with self; [
      nvim-lspconfig
      otter-nvim
    ];
    nvimSkipModules = [
      "quarto.runner.init"
    ];
  };

  range-highlight-nvim = super.range-highlight-nvim.overrideAttrs {
    dependencies = [ self.cmd-parser-nvim ];
  };

  ranger-nvim = super.ranger-nvim.overrideAttrs {
    patches = [ ./patches/ranger.nvim/fix-paths.patch ];

    postPatch = ''
      substituteInPlace lua/ranger-nvim.lua --replace-fail '@ranger@' ${ranger}/bin/ranger
    '';
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
    nvimSkipModules = [ "repro" ];
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

  rocks-nvim = super.rocks-nvim.overrideAttrs (oa: {
    passthru = oa.passthru // {
      initLua = ''
        vim.g.rocks_nvim = {
          luarocks_binary = "${neovim-unwrapped.lua.pkgs.luarocks_bootstrap}/bin/luarocks"
          }
      '';
    };

  });

  rustaceanvim = super.rustaceanvim.overrideAttrs {
    checkInputs = [
      # Optional integration
      self.neotest
    ];
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

  schema-companion-nvim = super.schema-companion-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  scretch-nvim = super.scretch-nvim.overrideAttrs {
  };

  searchbox-nvim = super.searchbox-nvim.overrideAttrs {
    dependencies = [ self.nui-nvim ];
  };

  search-and-replace-nvim = super.search-and-replace-nvim.overrideAttrs {
    runtimeDeps = [
      fd
      sad
    ];
  };

  sidekick-nvim = super.sidekick-nvim.overrideAttrs {
    runtimeDeps = [
      copilot-language-server
    ];

    nvimSkipModules = [
      "sidekick.docs"
    ];
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
    nvimSkipModules = [
      # optional dependency
      "smart-open.matching.algorithms.fzf_implementation"
    ];
  };

  smart-splits-nvim = super.smart-splits-nvim.overrideAttrs {
    nvimSkipModules = [
      "vimdoc-gen"
      "vimdocrc"
    ];
  };

  snacks-nvim = super.snacks-nvim.overrideAttrs {
    # Optional trouble integration
    checkInputs = [ self.trouble-nvim ];
    nvimSkipModules = [
      # Requires setup call first
      # attempt to index global 'Snacks' (a nil value)
      "snacks.dashboard"
      "snacks.debug"
      "snacks.dim"
      "snacks.explorer.init"
      "snacks.gh.actions"
      "snacks.gh.buf"
      "snacks.gh.init"
      "snacks.gh.render"
      "snacks.gh.render.init"
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
      "snacks.picker.source.gh"
      "snacks.picker.util.diff"
      "snacks.scratch"
      "snacks.scroll"
      "snacks.terminal"
      "snacks.win"
      "snacks.words"
      "snacks.zen"
      # TODO: Plugin requires libsqlite available, create a test for it
      "snacks.picker.util.db"
    ];
  };

  snap = super.snap.overrideAttrs {
    nvimSkipModules = [
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

  solarized-osaka-nvim = super.solarized-osaka-nvim.overrideAttrs {
    checkInputs = [ self.fzf-lua ];

    nvimSkipModules = [
      # lua/solarized-osaka/extra/fzf.lua:55: color not found for header:FzfLuaTitle
      "solarized-osaka.extra.fzf"
    ];
  };

  spaceman-nvim = super.spaceman-nvim.overrideAttrs {
    # Optional telescope integration
    nvimSkipModules = "spaceman.adapters.telescope";
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

      nvimSkipModules = [
        # Require "sql.utils" ?
        "sqlite.tbl.cache"
        # attempt to write to read only database
        "sqlite.examples.bookmarks"
      ];
    }
  );

  ssr-nvim = super.ssr-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  startup-nvim = super.startup-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
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
    super.sved.overrideAttrs (old: {

      postPatch = ''
        rm ftplugin/evinceSync.py
        install -m 544 ${pythonWrapper} ftplugin/evinceSync.py
      '';
      meta = old.meta // {
        description = "synctex support between vim/neovim and evince";
      };
    });

  syntax-tree-surfer = super.syntax-tree-surfer.overrideAttrs (old: {
    dependencies = [ self.nvim-treesitter ];

    meta = old.meta // {
      maintainers = with lib.maintainers; [ callumio ];
    };
  });

  tardis-nvim = super.tardis-nvim.overrideAttrs (old: {
    dependencies = [ self.plenary-nvim ];
    meta = old.meta // {
      maintainers = with lib.maintainers; [ fredeb ];
    };
  });
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
    nvimSkipModules = "frecency.types";
  };

  telescope-fzf-native-nvim = super.telescope-fzf-native-nvim.overrideAttrs (old: {
    dependencies = [ self.telescope-nvim ];
    buildPhase = "make";
    meta = old.meta // {
      platforms = lib.platforms.all;
    };
  });

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
    meta = old.meta // {
      platforms = lib.platforms.all;
    };
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

  telescope-zoxide = super.telescope-zoxide.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];

    buildInputs = [ zoxide ];

    postPatch = ''
      substituteInPlace lua/telescope/_extensions/zoxide/config.lua \
        --replace-fail "zoxide query -ls" "${zoxide}/bin/zoxide query -ls"
    '';
  };

  text-case-nvim = super.text-case-nvim.overrideAttrs {
    nvimSkipModules = [
      # some leftover from development
      "textcase.plugin.range"
    ];
  };

  timerly = super.timerly.overrideAttrs {
    dependencies = [ self.nvzone-volt ];
  };

  tmux-complete-vim = super.tmux-complete-vim.overrideAttrs {
    # Vim plugin with optional nvim-compe lua module
    nvimSkipModules = [ "compe_tmux" ];
  };

  todo-comments-nvim = super.todo-comments-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional trouble integration
      trouble-nvim
    ];
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
      # Optional fzf-lua integration
      # fzf-lua server must be running
      "todo-comments.fzf"
    ];
  };

  tokyonight-nvim = super.tokyonight-nvim.overrideAttrs {
    checkInputs = [ self.fzf-lua ];
    nvimSkipModules = [
      # Meta file
      "tokyonight.docs"
      # Optional integration
      "tokyonight.extra.fzf"
    ];
  };

  triptych-nvim = super.triptych-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  trouble-nvim = super.trouble-nvim.overrideAttrs {
    # Meta file
    nvimSkipModules = "trouble.docs";
  };

  tsc-nvim = super.tsc-nvim.overrideAttrs {
    patches = [ ./patches/tsc.nvim/fix-path.patch ];

    postPatch = ''
      substituteInPlace lua/tsc/utils.lua --replace-fail '@tsc@' ${typescript}/bin/tsc
    '';

    # Unit test
    nvimSkipModules = "tsc.better-messages-test";
  };

  tssorter-nvim = super.tssorter-nvim.overrideAttrs {
    dependencies = [ self.nvim-treesitter ];
  };

  typescript-nvim = super.typescript-nvim.overrideAttrs {
    checkInputs = [
      # Optional null-ls integration
      self.none-ls-nvim
    ];
    dependencies = with self; [
      nvim-lspconfig
    ];
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

  typst-preview-nvim = super.typst-preview-nvim.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/typst-preview/config.lua \
       --replace-fail "['tinymist'] = nil," "tinymist = '${lib.getExe tinymist}'," \
       --replace-fail "['websocat'] = nil," "websocat = '${lib.getExe websocat}',"
    '';

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

  uv-nvim = super.uv-nvim.overrideAttrs {
    runtimeDeps = [ uv ];
  };

  vCoolor-vim = super.vCoolor-vim.overrideAttrs (old: {
    # on linux can use either Zenity or Yad.
    propagatedBuildInputs = [ zenity ];
    meta = old.meta // {
      description = "Simple color selector/picker plugin";
      license = lib.licenses.publicDomain;
    };
  });

  vimacs = super.vimacs.overrideAttrs (old: {
    buildPhase = ''
      substituteInPlace bin/vim \
        --replace-fail '/usr/bin/vim' 'vim' \
        --replace-fail '/usr/bin/gvim' 'gvim'
      # remove unnecessary duplicated bin wrapper script
      rm -r plugin/vimacs
    '';
    meta = old.meta // {
      description = "Vim-Improved eMACS: Emacs emulation plugin for Vim";
      homepage = "http://algorithm.com.au/code/vimacs";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ millerjason ];
    };
  });

  vimade = super.vimade.overrideAttrs {
    checkInputs = with self; [
      # Optional providers
      hlchunk-nvim
      mini-nvim
      snacks-nvim
    ];
  };

  vimsence = super.vimsence.overrideAttrs (old: {
    meta = old.meta // {
      description = "Discord rich presence for Vim";
      homepage = "https://github.com/hugolgst/vimsence";
      maintainers = with lib.maintainers; [ hugolgst ];
    };
  });

  vimtex = super.vimtex.overrideAttrs {
    checkInputs = with self; [
      # Optional integrations
      fzf-lua
      snacks-nvim
    ];
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
    nvimSkipModules = [ "run" ];
  };

  vim-bazel = super.vim-bazel.overrideAttrs {
    dependencies = [ self.vim-maktaba ];
  };

  vim-beancount = super.vim-beancount.overrideAttrs {
    passthru.python3Dependencies = ps: with ps; [ beancount ];
  };

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
    nvimSkipModules = "flog.graph_bin";
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

    meta = old.meta // {
      platforms = lib.platforms.all;
    };
  });

  vim-hier = super.vim-hier.overrideAttrs {
    buildInputs = [ vim ];
  };

  vim-illuminate = super.vim-illuminate.overrideAttrs {
    # Optional treesitter integration
    checkInputs = [ self.nvim-treesitter ];
  };

  vim-isort = super.vim-isort.overrideAttrs {
    postPatch = ''
      substituteInPlace autoload/vimisort.vim \
        --replace-fail 'import vim' 'import vim; import sys; sys.path.append("${python3.pkgs.isort}/${python3.sitePackages}")'
    '';
  };

  vim-matchup = super.vim-matchup.overrideAttrs {
    # Optional treesitter integration
    nvimSkipModules = "treesitter-matchup.third-party.query";
  };

  vim-mediawiki-editor = super.vim-mediawiki-editor.overrideAttrs {
    passthru.python3Dependencies = [ python3.pkgs.mwclient ];
  };

  vim-metamath = super.vim-metamath.overrideAttrs {
    preInstall = "cd vim";
  };

  vim-pluto = super.vim-pluto.overrideAttrs {
    dependencies = [ self.denops-vim ];
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

  vim-stylish-haskell = super.vim-stylish-haskell.overrideAttrs (old: {
    postPatch = old.postPatch or "" + ''
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

  vim-textobj-entire = super.vim-textobj-entire.overrideAttrs (old: {
    dependencies = [ self.vim-textobj-user ];
    meta = old.meta // {
      maintainers = with lib.maintainers; [ workflow ];
    };
  });

  vim-textobj-line = super.vim-textobj-line.overrideAttrs (old: {
    dependencies = [ self.vim-textobj-user ];
    meta = old.meta // {
      maintainers = with lib.maintainers; [ llakala ];
    };
  });

  vim-tpipeline = super.vim-tpipeline.overrideAttrs {
    # Requires global variable
    nvimSkipModules = "tpipeline.main";
  };

  vim-ultest = super.vim-ultest.overrideAttrs {
    # NOTE: vim-ultest is no longer maintained.
    # If using Neovim, you can switch to using neotest (https://github.com/nvim-neotest/neotest) instead.
    nvimSkipModules = [ "ultest" ];
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

  vim-zettel = super.vim-zettel.overrideAttrs {
    dependencies = with self; [
      vimwiki
      fzf-vim
    ];
  };

  virt-column-nvim = super.virt-column-nvim.overrideAttrs {
    # Meta file
    nvimSkipModules = "virt-column.config.types";
  };

  vs-tasks-nvim = super.vs-tasks-nvim.overrideAttrs {
    checkInputs = [
      # Optional telescope integration
      self.telescope-nvim
    ];
    dependencies = [
      self.plenary-nvim
    ];
  };

  vscode-diff-nvim = super.vscode-diff-nvim.overrideAttrs {
    dependencies = [
      self.nui-nvim
    ];
    nativeBuildInputs = [ cmake ];
    dontUseCmakeConfigure = true;
    buildPhase = ''
      runHook preBuild
      make
      runHook postBuild
    '';
  };

  which-key-nvim = super.which-key-nvim.overrideAttrs {
    nvimSkipModules = [ "which-key.docs" ];
  };

  whichpy-nvim = super.whichpy-nvim.overrideAttrs {
    checkInputs = [
      # Optional telescope integration
      self.telescope-nvim
    ];
  };

  wiki-vim = super.wiki-vim.overrideAttrs {
    checkInputs = [
      # Optional picker integration
      self.telescope-nvim
      self.fzf-lua
    ];
  };

  windows-nvim = super.windows-nvim.overrideAttrs {
    dependencies = with self; [
      middleclass
      animation-nvim
    ];
    nvimSkipModules = [
      # Animation doesn't work headless
      "windows.autowidth"
      "windows.commands"
    ];
  };

  wtf-nvim = super.wtf-nvim.overrideAttrs {
    dependencies = with self; [
      nui-nvim
      plenary-nvim
    ];
  };

  xmake-nvim = super.xmake-nvim.overrideAttrs {
    nvimSkipModule = [
      # attempt to index upvalue 'options' (a nil value)
      "xmake.action"
      "xmake.command"
      "xmake.runner_wrapper"
    ];
  };

  yaml-companion-nvim = super.yaml-companion-nvim.overrideAttrs {
    dependencies = [
      self.nvim-lspconfig
      self.plenary-nvim
    ];
  };

  yaml-schema-detect-nvim = super.yaml-schema-detect-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      nvim-lspconfig
    ];
  };

  yanky-nvim = super.yanky-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional telescope integration
      telescope-nvim
    ];
  };

  yazi-nvim = super.yazi-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimSkipModules = [
      # Used for reproducing issues
      "repro"
    ];
  };

  YouCompleteMe = super.YouCompleteMe.overrideAttrs (old: {
    buildPhase = ''
      substituteInPlace plugin/youcompleteme.vim \
        --replace-fail "'ycm_path_to_python_interpreter', '''" \
        "'ycm_path_to_python_interpreter', '${python3}/bin/python3'"

      rm -r third_party/ycmd
      ln -s ${ycmd}/lib/ycmd third_party
    '';

    meta = old.meta // {
      description = "Code-completion engine for Vim";
      homepage = "https://github.com/Valloric/YouCompleteMe";
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [
        marcweber
        jagajaga
        mel
      ];
      platforms = lib.platforms.unix;
    };
  });

  zenbones-nvim = super.zenbones-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional lush-nvim integration
      lush-nvim
    ];
    nvimSkipModules = [
      # Requires global variable set
      "randombones"
      "randombones.palette"
      "randombones_dark.palette"
      "randombones_light"
      "randombones_light.palette"
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
      "randombones_dark"
    ];
  };

  zk-nvim = super.zk-nvim.overrideAttrs {
    checkInputs = with self; [
      # Optional pickers
      fzf-lua
      mini-nvim
      snacks-nvim
      telescope-nvim
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
  # keep-sorted end
}
