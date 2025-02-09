{ lib
, stdenv
, # nixpkgs functions
  buildGoModule
, buildVimPlugin
, fetchFromGitHub
, fetchFromSourcehut
, fetchpatch
, fetchurl
, substituteAll
, # Language dependencies
  fetchYarnDeps
, mkYarnModules
, python3
, rustPlatform
, # Misc dependencies
  Cocoa
, code-minimap
, dasht
, deno
, direnv
, fish
, fzf
, gawk
, git
, gnome
, himalaya
, htop
, jq
, khard
, languagetool
, llvmPackages
, meson
, nim1
, nodePackages
, openscad
, pandoc
, parinfer-rust
, phpactor
, ripgrep
, skim
, sqlite
, statix
, stylish-haskell
, tabnine
, taskwarrior
, tmux
, tup
, vim
, which
, xkb-switch
, ycmd
, zoxide
, nodejs
, xdotool
, xorg
, xxd
, zathura
, zsh
, # codeium-nvim dependencies
  codeium
, # command-t dependencies
  getconf
, ruby
, # cpsm dependencies
  boost
, cmake
, icu
, ncurses
, # LanguageClient-neovim dependencies
  CoreFoundation
, CoreServices
, # nvim-treesitter dependencies
  callPackage
, # sg.nvim dependencies
  darwin
, # sved dependencies
  glib
, gobject-introspection
, wrapGAppsHook
, # sniprun dependencies
  bashInteractive
, coreutils
, curl
, gnugrep
, gnused
, makeWrapper
, procps
, # sg-nvim dependencies
  openssl
, pkg-config
, # vim-agda dependencies
  agda
, # vim-go dependencies
  asmfmt
, delve
, errcheck
, go-motion
, go-tools
, gocode
, gocode-gomod
, godef
, gogetdoc
, golangci-lint
, golint
, gomodifytags
, gopls
, gotags
, gotools
, iferr
, impl
, reftools
, # hurl dependencies
  hurl
, # must be lua51Packages
  luaPackages
, luajitPackages
,
}: self: super:
{
  alpha-nvim = super.alpha-nvim.overrideAttrs {
    dependencies = [
      self.nvim-web-devicons # required by the startify theme
    ];
    nvimRequireCheck = "alpha";
  };

  autosave-nvim = super.autosave-nvim.overrideAttrs {
    dependencies = with super; [ plenary-nvim ];
  };

  barbecue-nvim = super.barbecue-nvim.overrideAttrs {
    dependencies = with self; [ nvim-lspconfig nvim-navic nvim-web-devicons ];
    meta = {
      description = "A VS Code like winbar for Neovim";
      homepage = "https://github.com/utilyre/barbecue.nvim";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ lightquantum ];
    };
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

  chadtree = super.chadtree.overrideAttrs {
    passthru.python3Dependencies = ps:
      with ps; [
        pynvim-pp
        pyyaml
        std2
      ];

    # We need some patches so it stops complaining about not being in a venv
    patches = [ ./patches/chadtree/emulate-venv.patch ];
  };

  ChatGPT-nvim = super.ChatGPT-nvim.overrideAttrs {
    dependencies = with self; [ nui-nvim plenary-nvim telescope-nvim ];
  };

  clang_complete = super.clang_complete.overrideAttrs {
    # In addition to the arguments you pass to your compiler, you also need to
    # specify the path of the C++ std header (if you are using C++).
    # These usually implicitly set by cc-wrapper around clang (pkgs/build-support/cc-wrapper).
    # The linked ruby code shows generates the required '.clang_complete' for cmake based projects
    # https://gist.github.com/Mic92/135e83803ed29162817fce4098dec144
    preFixup =
      ''
        substituteInPlace "$out"/plugin/clang_complete.vim \
          --replace "let g:clang_library_path = ''
      + "''"
      + ''        " "let g:clang_library_path='${llvmPackages.libclang.lib}/lib/libclang.so'"

              substituteInPlace "$out"/plugin/libclang.py \
                --replace "/usr/lib/clang" "${llvmPackages.clang.cc}/lib/clang"
      '';
  };

  clighter8 = super.clighter8.overrideAttrs {
    preFixup = ''
      sed "/^let g:clighter8_libclang_path/s|')$|${llvmPackages.clang.cc.lib}/lib/libclang.so')|" \
        -i "$out"/plugin/clighter8.vim
    '';
  };

  clipboard-image-nvim = super.clipboard-image-nvim.overrideAttrs {
    postPatch = ''
      sed -i -e 's/require "health"/vim.health/' lua/clipboard-image/health.lua
    '';
  };

  cmp-clippy = super.cmp-clippy.overrideAttrs {
    dependencies = with self; [ nvim-cmp plenary-nvim ];
  };

  cmp-copilot = super.cmp-copilot.overrideAttrs {
    dependencies = with self; [ nvim-cmp copilot-vim ];
  };

  cmp-dap = super.cmp-dap.overrideAttrs {
    dependencies = with self; [ nvim-cmp nvim-dap ];
  };

  cmp-dictionary = super.cmp-dictionary.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-digraphs = super.cmp-digraphs.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-fish = super.cmp-fish.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-fuzzy-buffer = super.cmp-fuzzy-buffer.overrideAttrs {
    dependencies = with self; [ nvim-cmp fuzzy-nvim ];
  };

  cmp-fuzzy-path = super.cmp-fuzzy-path.overrideAttrs {
    dependencies = with self; [ nvim-cmp fuzzy-nvim ];
  };

  cmp-git = super.cmp-git.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-greek = super.cmp-greek.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-look = super.cmp-look.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-neosnippet = super.cmp-neosnippet.overrideAttrs {
    dependencies = with self; [ nvim-cmp neosnippet-vim ];
  };

  cmp-npm = super.cmp-npm.overrideAttrs {
    dependencies = with self; [ nvim-cmp plenary-nvim ];
  };

  cmp-nvim-lsp-signature-help = super.cmp-nvim-lsp-signature-help.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-nvim-tags = super.cmp-nvim-tags.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-pandoc-nvim = super.cmp-pandoc-nvim.overrideAttrs {
    dependencies = with self; [ nvim-cmp plenary-nvim ];
  };

  cmp-rg = super.cmp-rg.overrideAttrs {
    dependencies = with self; [ nvim-cmp ];
  };

  cmp-snippy = super.cmp-snippy.overrideAttrs {
    dependencies = with self; [ nvim-cmp nvim-snippy ];
  };

  cmp-tabnine = super.cmp-tabnine.overrideAttrs {
    buildInputs = [ tabnine ];

    postFixup = ''
      mkdir -p $target/binaries/${tabnine.version}
      ln -s ${tabnine}/bin/ $target/binaries/${tabnine.version}/${tabnine.passthru.platform}
    '';
  };

  cmp-tmux = super.cmp-tmux.overrideAttrs {
    dependencies = with self; [ nvim-cmp tmux ];
  };

  cmp-vim-lsp = super.cmp-vim-lsp.overrideAttrs {
    dependencies = with self; [ nvim-cmp vim-lsp ];
  };

  cmp-vimwiki-tags = super.cmp-vimwiki-tags.overrideAttrs {
    dependencies = with self; [ nvim-cmp vimwiki ];
  };

  cmp-zsh = super.cmp-zsh.overrideAttrs {
    dependencies = with self; [ nvim-cmp zsh ];
  };

  coc-nginx = buildVimPlugin {
    pname = "coc-nginx";
    inherit (nodePackages."@yaegassy/coc-nginx") version meta;
    src = "${nodePackages."@yaegassy/coc-nginx"}/lib/node_modules/@yaegassy/coc-nginx";
  };

  codeium-nvim = super.codeium-nvim.overrideAttrs {
    dependencies = with self; [ nvim-cmp plenary-nvim ];
    buildPhase = ''
      cat << EOF > lua/codeium/installation_defaults.lua
      return {
        tools = {
          language_server = "${codeium}/bin/codeium_language_server"
        };
      };
      EOF
    '';
  };

  command-t = super.command-t.overrideAttrs {
    nativeBuildInputs = [ getconf ruby ];
    buildPhase = ''
      substituteInPlace lua/wincent/commandt/lib/Makefile \
        --replace '/bin/bash' 'bash' \
        --replace xcrun ""
      make build
      rm ruby/command-t/ext/command-t/*.o
    '';
  };

  compe-tabnine = super.compe-tabnine.overrideAttrs {
    buildInputs = [ tabnine ];

    postFixup = ''
      mkdir -p $target/binaries/${tabnine.version}
      ln -s ${tabnine}/bin/ $target/binaries/${tabnine.version}/${tabnine.passthru.platform}
    '';
  };

  compiler-explorer-nvim = super.compiler-explorer-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  completion-buffers = super.completion-buffers.overrideAttrs {
    dependencies = with self; [ completion-nvim ];
  };

  completion-tabnine = super.completion-tabnine.overrideAttrs {
    dependencies = with self; [ completion-nvim ];
    buildInputs = [ tabnine ];
    postFixup = ''
      mkdir -p $target/binaries
      ln -s ${tabnine}/bin/TabNine $target/binaries/TabNine_$(uname -s)
    '';
  };

  completion-treesitter = super.completion-treesitter.overrideAttrs {
    dependencies = with self; [ completion-nvim nvim-treesitter ];
  };

  copilot-vim = super.copilot-vim.overrideAttrs {
    postInstall = ''
      substituteInPlace $out/autoload/copilot/agent.vim \
        --replace "  let node = get(g:, 'copilot_node_command', ''\'''\')" \
                  "  let node = get(g:, 'copilot_node_command', '${nodejs}/bin/node')"
    '';
  };

  coq_nvim = super.coq_nvim.overrideAttrs {
    passthru.python3Dependencies = ps:
      with ps; [
        pynvim-pp
        pyyaml
        std2
      ];

    # We need some patches so it stops complaining about not being in a venv
    patches = [ ./patches/coq_nvim/emulate-venv.patch ];
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
    dependencies = with self; [ plenary-nvim ];
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
    buildInputs = with python3.pkgs; [ python3 setuptools ];
    buildPhase = ''
      patchShebangs .
      ./install.sh
    '';
  };

  defx-nvim = super.defx-nvim.overrideAttrs {
    dependencies = with self; [ nvim-yarp ];
  };

  denops-vim = super.denops-vim.overrideAttrs {
    postPatch = ''
      # Use Nix's Deno instead of an arbitrary install
      substituteInPlace ./autoload/denops.vim --replace "call denops#_internal#conf#define('denops#deno', 'deno')" "call denops#_internal#conf#define('denops#deno', '${deno}/bin/deno')"
    '';
  };

  deoplete-fish = super.deoplete-fish.overrideAttrs {
    dependencies = with self; [ deoplete-nvim vim-fish ];
  };

  deoplete-go = super.deoplete-go.overrideAttrs {
    buildInputs = [ python3 ];
    buildPhase = ''
      pushd ./rplugin/python3/deoplete/ujson
      python3 setup.py build --build-base=$PWD/build --build-lib=$PWD/build
      popd
      find ./rplugin/ -name "ujson*.so" -exec mv -v {} ./rplugin/python3/ \;
    '';
  };

  deoplete-khard = super.deoplete-khard.overrideAttrs {
    dependencies = with self; [ deoplete-nvim ];
    passthru.python3Dependencies = ps: [ (ps.toPythonModule khard) ];
    meta = {
      description = "Address-completion for khard via deoplete";
      homepage = "https://github.com/nicoe/deoplete-khard";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ jorsn ];
    };
  };

  diffview-nvim = super.diffview-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];

    doInstallCheck = true;
    nvimRequireCheck = "diffview";
  };

  direnv-vim = super.direnv-vim.overrideAttrs (old: {
    preFixup =
      old.preFixup
        or ""
      + ''
        substituteInPlace $out/autoload/direnv.vim \
          --replace "let s:direnv_cmd = get(g:, 'direnv_cmd', 'direnv')" \
            "let s:direnv_cmd = get(g:, 'direnv_cmd', '${lib.getBin direnv}/bin/direnv')"
      '';
  });

  executor-nvim = super.executor-nvim.overrideAttrs {
    dependencies = with self; [ nui-nvim ];
  };

  fcitx-vim = super.fcitx-vim.overrideAttrs {
    passthru.python3Dependencies = ps: with ps; [ dbus-python ];
    meta = {
      description = "Keep and restore fcitx state when leaving/re-entering insert mode or search mode";
      license = lib.licenses.mit;
    };
  };

  flit-nvim = super.flit-nvim.overrideAttrs {
    dependencies = with self; [ leap-nvim ];
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
        (substituteAll {
          src = ./patches/fruzzy/get_version.patch;
          inherit (old) version;
        })
      ];
      configurePhase = ''
        substituteInPlace Makefile \
          --replace \
            "nim c" \
            "nim c --nimcache:$TMP --path:${nimpy} --path:${binaryheap}"
      '';
      buildPhase = ''
        make build
      '';
    });

  fuzzy-nvim = super.fuzzy-nvim.overrideAttrs {
    dependencies = with self; [ telescope-fzf-native-nvim ];
  };

  fzf-checkout-vim = super.fzf-checkout-vim.overrideAttrs {
    # The plugin has a makefile which tries to run tests in a docker container.
    # This prevents it.
    prePatch = ''
      rm Makefile
    '';
  };

  fzf-hoogle-vim = super.fzf-hoogle-vim.overrideAttrs {
    # add this to your lua config to prevent the plugin from trying to write in the
    # nix store:
    # vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json'
    propagatedBuildInputs = [
      jq
      gawk
    ];
    dependencies = with self; [ fzf-vim ];
  };

  fzf-lua = super.fzf-lua.overrideAttrs {
    propagatedBuildInputs = [ fzf ];
  };

  fzf-vim = super.fzf-vim.overrideAttrs {
    dependencies = with self; [ fzfWrapper ];
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

  gitlinker-nvim = super.gitlinker-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  gitsigns-nvim = super.gitsigns-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  guard-nvim = super.guard-nvim.overrideAttrs {
    dependencies = with self; [ guard-collection ];
  };

  harpoon = super.harpoon.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  harpoon2 = super.harpoon2.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  hex-nvim = super.hex-nvim.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/hex.lua --replace xxd ${xxd}/bin/xxd
    '';
  };

  himalaya-vim = super.himalaya-vim.overrideAttrs {
    buildInputs = [ himalaya ];
    src = fetchFromSourcehut {
      owner = "~soywod";
      repo = "himalaya-vim";
      rev = "v${himalaya.version}";
      sha256 = "W+91hnNeS6WkDiR9r1s7xPTK9JlCWiVkI/nXVYbepY0=";
    };
  };

  # https://hurl.dev/
  hurl = buildVimPlugin {
    pname = "hurl";
    version = hurl.version;
    # dontUnpack = true;

    src = "${hurl.src}/contrib/vim";
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
        --replace @nix_magick@ ${luajitPackages.magick}
    '';

    nvimRequireCheck = "image";
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
    dependencies = with self; [ lush-nvim ];
  };

  LanguageClient-neovim =
    let
      version = "0.1.161";
      LanguageClient-neovim-src = fetchFromGitHub {
        owner = "autozimu";
        repo = "LanguageClient-neovim";
        rev = version;
        sha256 = "Z9S2ie9RxJCIbmjSV/Tto4lK04cZfWmK3IAy8YaySVI=";
      };
      LanguageClient-neovim-bin = rustPlatform.buildRustPackage {
        pname = "LanguageClient-neovim-bin";
        inherit version;
        src = LanguageClient-neovim-src;

        cargoSha256 = "H34UqJ6JOwuSABdOup5yKeIwFrGc83TUnw1ggJEx9o4=";
        buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

        # FIXME: Use impure version of CoreFoundation because of missing symbols.
        #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
        preConfigure = lib.optionalString stdenv.isDarwin ''
          export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
        '';
      };
    in
    buildVimPlugin {
      pname = "LanguageClient-neovim";
      inherit version;
      src = LanguageClient-neovim-src;

      propagatedBuildInputs = [ LanguageClient-neovim-bin ];

      preFixup = ''
        substituteInPlace "$out"/autoload/LanguageClient.vim \
          --replace "let l:path = s:root . '/bin/'" "let l:path = '${LanguageClient-neovim-bin}' . '/bin/'"
      '';
    };

  lazy-lsp-nvim = super.lazy-lsp-nvim.overrideAttrs {
    dependencies = with self; [ nvim-lspconfig ];
  };

  lazy-nvim = super.lazy-nvim.overrideAttrs {
    patches = [ ./patches/lazy-nvim/no-helptags.patch ];
  };

  lean-nvim = super.lean-nvim.overrideAttrs {
    dependencies = with self; [ nvim-lspconfig plenary-nvim ];
  };

  leap-ast-nvim = super.leap-ast-nvim.overrideAttrs {
    dependencies = with self; [ leap-nvim nvim-treesitter ];
  };

  lens-vim = super.lens-vim.overrideAttrs {
    # remove duplicate g:lens#animate in doc/lens.txt
    # https://github.com/NixOS/nixpkgs/pull/105810#issuecomment-740007985
    # https://github.com/camspiers/lens.vim/pull/40/files
    patches = [
      (substituteAll {
        src = ./patches/lens-vim/remove_duplicate_g_lens_animate.patch;
        inherit languagetool;
      })
    ];
  };

  lf-vim = super.lf-vim.overrideAttrs {
    dependencies = with self; [ vim-floaterm ];
  };

  lir-nvim = super.lir-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  magma-nvim-goose = buildVimPlugin {
    pname = "magma-nvim-goose";
    version = "2023-03-13";
    src = fetchFromGitHub {
      owner = "WhiteBlackGoose";
      repo = "magma-nvim-goose";
      rev = "5d916c39c1852e09fcd39eab174b8e5bbdb25f8f";
      sha256 = "10d6dh0czdpgfpzqs5vzxfffkm0460qjzi2mfkacgghqf3iwkbja";
    };
    passthru.python3Dependencies = ps:
      with ps; [
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
    meta.homepage = "https://github.com/WhiteBlackGoose/magma-nvim-goose/";
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
        (substituteAll {
          src = ./markdown-preview-nvim/fix-node-paths.patch;
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

  mason-lspconfig-nvim = super.mason-lspconfig-nvim.overrideAttrs {
    dependencies = with self; [ mason-nvim nvim-lspconfig ];
  };

  mason-tool-installer-nvim = super.mason-tool-installer-nvim.overrideAttrs {
    dependencies = with self; [ mason-nvim ];
  };

  meson = buildVimPlugin {
    inherit (meson) pname version src;
    preInstall = "cd data/syntax-highlighting/vim";
    meta.maintainers = with lib.maintainers; [ vcunat ];
  };

  minimap-vim = super.minimap-vim.overrideAttrs {
    preFixup = ''
      substituteInPlace $out/plugin/minimap.vim \
        --replace "code-minimap" "${code-minimap}/bin/code-minimap"
      substituteInPlace $out/bin/minimap_generator.sh \
        --replace "code-minimap" "${code-minimap}/bin/code-minimap"
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

  multicursors-nvim = super.multicursors-nvim.overrideAttrs {
    dependencies = with self; [ nvim-treesitter hydra-nvim ];
  };

  ncm2 = super.ncm2.overrideAttrs {
    dependencies = with self; [ nvim-yarp ];
  };

  ncm2-jedi = super.ncm2-jedi.overrideAttrs {
    dependencies = with self; [ nvim-yarp ncm2 ];
    passthru.python3Dependencies = ps: with ps; [ jedi ];
  };

  ncm2-neoinclude = super.ncm2-neoinclude.overrideAttrs {
    dependencies = with self; [ neoinclude-vim ];
  };

  ncm2-neosnippet = super.ncm2-neosnippet.overrideAttrs {
    dependencies = with self; [ neosnippet-vim ];
  };

  ncm2-syntax = super.ncm2-syntax.overrideAttrs {
    dependencies = with self; [ neco-syntax ];
  };

  ncm2-ultisnips = super.ncm2-ultisnips.overrideAttrs {
    dependencies = with self; [ ultisnips ];
  };

  neogit = super.neogit.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  neorg = super.neorg.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  neotest = super.neotest.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  neo-tree-nvim = super.neo-tree-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim nui-nvim ];
  };

  noice-nvim = super.noice-nvim.overrideAttrs {
    dependencies = with self; [ nui-nvim ];
  };

  null-ls-nvim = super.null-ls-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  nvim-coverage = super.nvim-coverage.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  nvim-dap-python = super.nvim-dap-python.overrideAttrs {
    dependencies = with self; [ nvim-dap ];
  };

  nvim-lsputils = super.nvim-lsputils.overrideAttrs {
    dependencies = with self; [ popfix ];
  };

  nvim-metals = super.nvim-metals.overrideAttrs {
    dontBuild = true;
  };

  nvim-navbuddy = super.nvim-navbuddy.overrideAttrs {
    dependencies = with self; [ nui-nvim nvim-lspconfig nvim-navic ];
  };

  vim-mediawiki-editor = super.vim-mediawiki-editor.overrideAttrs {
    passthru.python3Dependencies = [ python3.pkgs.mwclient ];
  };

  nvim-navic = super.nvim-navic.overrideAttrs {
    dependencies = with self; [ nvim-lspconfig ];
  };

  nvim-spectre = super.nvim-spectre.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  nvim-teal-maker = super.nvim-teal-maker.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/tealmaker/init.lua \
        --replace cyan ${luaPackages.cyan}/bin/cyan
    '';
    vimCommandCheck = "TealBuild";
  };

  nvim-treesitter = super.nvim-treesitter.overrideAttrs (
    callPackage ./nvim-treesitter/overrides.nix { } self super
  );
  nvim-treesitter-parsers = lib.recurseIntoAttrs self.nvim-treesitter.grammarPlugins;

  nvim-ufo = super.nvim-ufo.overrideAttrs {
    dependencies = with self; [ promise-async ];
  };

  obsidian-nvim = super.obsidian-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  octo-nvim = super.octo-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim plenary-nvim ];
  };

  ollama-nvim = super.ollama-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
  };

  onehalf = super.onehalf.overrideAttrs {
    configurePhase = "cd vim";
  };

  # The plugin depends on either skim-vim or fzf-vim, but we don't want to force the user so we
  # avoid choosing one of them and leave it to the user
  openscad-nvim = super.openscad-nvim.overrideAttrs {
    buildInputs = [ zathura htop openscad ];

    patches = [
      (substituteAll {
        src = ./patches/openscad.nvim/program_paths.patch;
        htop = lib.getExe htop;
        openscad = lib.getExe openscad;
        zathura = lib.getExe zathura;
      })
    ];
  };

  orgmode = super.orgmode.overrideAttrs {
    dependencies = with self; [ (nvim-treesitter.withPlugins (p: [ p.org ])) ];
  };

  overseer-nvim = super.overseer-nvim.overrideAttrs {
    doCheck = true;
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

  inherit parinfer-rust;

  phpactor = buildVimPlugin {
    inherit (phpactor) pname src meta version;
    postPatch = ''
      substituteInPlace plugin/phpactor.vim \
        --replace "g:phpactorpath = expand('<sfile>:p:h') . '/..'" "g:phpactorpath = '${phpactor}'"
    '';
  };

  playground = super.playground.overrideAttrs {
    dependencies = with self; [
      # we need the 'query' grammer to make
      (nvim-treesitter.withPlugins (p: [ p.query ]))
    ];
  };

  plenary-nvim = super.plenary-nvim.overrideAttrs {
    postPatch = ''
      sed -Ei lua/plenary/curl.lua \
          -e 's@(command\s*=\s*")curl(")@\1${curl}/bin/curl\2@'
    '';

    doInstallCheck = true;
    nvimRequireCheck = "plenary";
  };

  range-highlight-nvim = super.range-highlight-nvim.overrideAttrs {
    dependencies = with self; [ cmd-parser-nvim ];
  };

  refactoring-nvim = super.refactoring-nvim.overrideAttrs {
    dependencies = with self; [ nvim-treesitter plenary-nvim ];
  };

  # needs  "http" and "json" treesitter grammars too
  rest-nvim = super.rest-nvim.overrideAttrs {
    dependencies = with self; [
      plenary-nvim
      (nvim-treesitter.withPlugins (p: [ p.http p.json ]))
    ];
  };

  sg-nvim = super.sg-nvim.overrideAttrs (old:
    let
      sg-nvim-rust = rustPlatform.buildRustPackage {
        pname = "sg-nvim-rust";
        inherit (old) version src;

        cargoHash = "sha256-U+EGS0GMWzE2yFyMH04gXpR9lR7HRMgWBecqICfTUbE=";

        nativeBuildInputs = [ pkg-config ];

        buildInputs =
          [ openssl ]
          ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Security
            darwin.apple_sdk.frameworks.SystemConfiguration
          ];

        prePatch = ''
          rm .cargo/config.toml
        '';

        env.OPENSSL_NO_VENDOR = true;

        cargoBuildFlags = [ "--workspace" ];

        # tests are broken
        doCheck = false;
      };
    in
    {
      dependencies = with self; [ plenary-nvim ];
      postInstall = ''
        mkdir -p $out/target/debug
        ln -s ${sg-nvim-rust}/{bin,lib}/* $out/target/debug
      '';
    });

  skim = buildVimPlugin {
    pname = "skim";
    inherit (skim) version;
    src = skim.vim;
  };

  skim-vim = super.skim-vim.overrideAttrs {
    dependencies = [ self.skim ];
  };

  sniprun =
    let
      version = "1.3.10";
      src = fetchFromGitHub {
        owner = "michaelb";
        repo = "sniprun";
        rev = "refs/tags/v${version}";
        hash = "sha256-7tDREZ8ZXYySHrXVOh+ANT23CknJQvZJ8WtU5r0pOOQ=";
      };
      sniprun-bin = rustPlatform.buildRustPackage {
        pname = "sniprun-bin";
        inherit version src;

        buildInputs = lib.optionals stdenv.isDarwin [
          darwin.apple_sdk.frameworks.Security
        ];

        cargoHash = "sha256-n/HW+q4Xrme/ssS9Th5uFEUsDgkxRxKt2wSR8k08uHY=";

        nativeBuildInputs = [ makeWrapper ];

        postInstall = ''
          wrapProgram $out/bin/sniprun \
            --prefix PATH ${lib.makeBinPath [bashInteractive coreutils curl gnugrep gnused procps]}
        '';

        doCheck = false;
      };
    in
    buildVimPlugin {
      pname = "sniprun";
      inherit version src;

      patches = [ ./patches/sniprun/fix-paths.patch ];
      postPatch = ''
        substituteInPlace lua/sniprun.lua --replace '@sniprun_bin@' ${sniprun-bin}
      '';

      propagatedBuildInputs = [ sniprun-bin ];
    };

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

  sqlite-lua = super.sqlite-lua.overrideAttrs {
    postPatch =
      let
        libsqlite = "${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}";
      in
      ''
        substituteInPlace lua/sqlite/defs.lua \
          --replace "path = vim.g.sqlite_clib_path" "path = vim.g.sqlite_clib_path or ${lib.escapeShellArg libsqlite}"
      '';
  };

  ssr = super.ssr-nvim.overrideAttrs {
    dependencies = with self; [ nvim-treesitter ];
  };

  startup-nvim = super.startup-nvim.overrideAttrs {
    dependencies = with super; [ plenary-nvim ];
  };

  statix = buildVimPlugin rec {
    inherit (statix) pname src meta;
    version = "0.1.0";
    postPatch = ''
      # check that version is up to date
      grep 'pname = "statix-vim"' -A 1 flake.nix \
        | grep -F 'version = "${version}"'

      cd vim-plugin
      substituteInPlace ftplugin/nix.vim --replace statix ${statix}/bin/statix
      substituteInPlace plugin/statix.vim --replace statix ${statix}/bin/statix
    '';
  };

  stylish-nvim = super.stylish-nvim.overrideAttrs {
    postPatch = ''
      substituteInPlace lua/stylish/common/mouse_hover_handler.lua --replace xdotool ${xdotool}/bin/xdotool
      substituteInPlace lua/stylish/components/menu.lua --replace xdotool ${xdotool}/bin/xdotool
      substituteInPlace lua/stylish/components/menu.lua --replace xwininfo ${xorg.xwininfo}/bin/xwininfo
    '';
  };

  sved =
    let
      # we put the script in its own derivation to benefit the magic of wrapGAppsHook
      svedbackend = stdenv.mkDerivation {
        name = "svedbackend-${super.sved.name}";
        inherit (super.sved) src;
        nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
        buildInputs = [
          glib
          (python3.withPackages (ps: with ps; [ pygobject3 pynvim dbus-python ]))
        ];
        preferLocalBuild = true;
        installPhase = ''
          install -Dt $out/bin ftplugin/evinceSync.py
        '';
      };
    in
    super.sved.overrideAttrs {
      preferLocalBuild = true;
      postPatch = ''
        rm ftplugin/evinceSync.py
        ln -s ${svedbackend}/bin/evinceSync.py ftplugin/evinceSync.py
      '';
      meta = {
        description = "synctex support between vim/neovim and evince";
      };
    };

  taskwarrior = buildVimPlugin {
    inherit (taskwarrior) version pname;
    src = "${taskwarrior.src}/scripts/vim";
  };

  telescope-cheat-nvim = super.telescope-cheat-nvim.overrideAttrs {
    dependencies = with self; [ sqlite-lua telescope-nvim ];
  };

  telescope-frecency-nvim = super.telescope-frecency-nvim.overrideAttrs {
    dependencies = with self; [ sqlite-lua telescope-nvim ];
  };

  telescope-fzf-native-nvim = super.telescope-fzf-native-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
    buildPhase = "make";
    meta.platforms = lib.platforms.all;
  };

  telescope-fzf-writer-nvim = super.telescope-fzf-writer-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
  };

  telescope-fzy-native-nvim = super.telescope-fzy-native-nvim.overrideAttrs (old: {
    dependencies = with self; [ telescope-nvim ];
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

  telescope-media-files-nvim = super.telescope-media-files-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim popup-nvim plenary-nvim ];
  };

  telescope-nvim = super.telescope-nvim.overrideAttrs {
    dependencies = with self; [ plenary-nvim ];
  };

  telescope-symbols-nvim = super.telescope-symbols-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
  };

  telescope-undo-nvim = super.telescope-undo-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
  };

  telescope-z-nvim = super.telescope-z-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
  };

  telescope-zoxide = super.telescope-zoxide.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];

    buildInputs = [ zoxide ];

    postPatch = ''
      substituteInPlace lua/telescope/_extensions/zoxide/config.lua \
        --replace "zoxide query -ls" "${zoxide}/bin/zoxide query -ls"
    '';
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

  typescript-tools-nvim = super.typescript-tools-nvim.overrideAttrs {
    dependencies = with self; [ nvim-lspconfig plenary-nvim ];
  };

  unicode-vim =
    let
      unicode-data = fetchurl {
        url = "http://www.unicode.org/Public/UNIDATA/UnicodeData.txt";
        sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
      };
    in
    super.unicode-vim.overrideAttrs {
      # redirect to /dev/null else changes terminal color
      buildPhase = ''
        cp "${unicode-data}" autoload/unicode/UnicodeData.txt
        echo "Building unicode cache"
        ${vim}/bin/vim --cmd ":set rtp^=$PWD" -c 'ru plugin/unicode.vim' -c 'UnicodeCache' -c ':echohl Normal' -c ':q' > /dev/null
      '';
    };

  unison = super.unison.overrideAttrs {
    # Editor stuff isn't at top level
    postPatch = "cd editor-support/vim";
  };

  vCoolor-vim = super.vCoolor-vim.overrideAttrs {
    # on linux can use either Zenity or Yad.
    propagatedBuildInputs = [ gnome.zenity ];
    meta = {
      description = "Simple color selector/picker plugin";
      license = lib.licenses.publicDomain;
    };
  };

  vim-addon-actions = super.vim-addon-actions.overrideAttrs {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  };

  vim-addon-async = super.vim-addon-async.overrideAttrs {
    dependencies = with self; [ vim-addon-signs ];
  };

  vim-addon-background-cmd = super.vim-addon-background-cmd.overrideAttrs {
    dependencies = with self; [ vim-addon-mw-utils ];
  };

  vim-addon-completion = super.vim-addon-completion.overrideAttrs {
    dependencies = with self; [ tlib_vim ];
  };

  vim-addon-goto-thing-at-cursor = super.vim-addon-goto-thing-at-cursor.overrideAttrs {
    dependencies = with self; [ tlib_vim ];
  };

  vim-addon-manager = super.vim-addon-manager.overrideAttrs {
    buildInputs = lib.optional stdenv.isDarwin Cocoa;
  };

  vim-addon-mru = super.vim-addon-mru.overrideAttrs {
    dependencies = with self; [ vim-addon-other vim-addon-mw-utils ];
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
    dependencies = with self; [ vim-addon-completion vim-addon-background-cmd tlib_vim ];
  };

  vim-addon-syntax-checker = super.vim-addon-syntax-checker.overrideAttrs {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  };

  vim-addon-toggle-buffer = super.vim-addon-toggle-buffer.overrideAttrs {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  };

  vim-addon-xdebug = super.vim-addon-xdebug.overrideAttrs {
    dependencies = with self; [ webapi-vim vim-addon-mw-utils vim-addon-signs vim-addon-async ];
  };

  vim-agda = super.vim-agda.overrideAttrs {
    preFixup = ''
      substituteInPlace "$out"/autoload/agda.vim \
        --replace "jobstart(['agda'" "jobstart(['${agda}/bin/agda'"
    '';
  };

  vim-bazel = super.vim-bazel.overrideAttrs {
    dependencies = with self; [ vim-maktaba ];
  };

  vim-beancount = super.vim-beancount.overrideAttrs {
    passthru.python3Dependencies = ps: with ps; [ beancount ];
  };

  vim-clap = callPackage ./vim-clap { };

  vim-codefmt = super.vim-codefmt.overrideAttrs {
    dependencies = with self; [ vim-maktaba ];
  };

  # Due to case-sensitivety issues, the hash differs on Darwin systems, see:
  # https://github.com/NixOS/nixpkgs/issues/157609
  vim-colorschemes = super.vim-colorschemes.overrideAttrs (old: {
    src = old.src.overrideAttrs (srcOld: {
      postFetch =
        (srcOld.postFetch or "")
        + lib.optionalString (!stdenv.isDarwin) ''
          rm $out/colors/darkBlue.vim
        '';
    });
  });

  vim-dadbod-ui = super.vim-dadbod-ui.overrideAttrs {
    dependencies = with self; [ vim-dadbod ];
  };

  vim-dasht = super.vim-dasht.overrideAttrs {
    preFixup = ''
      substituteInPlace $out/autoload/dasht.vim \
        --replace "['dasht']" "['${dasht}/bin/dasht']"
    '';
  };

  vim-easytags = super.vim-easytags.overrideAttrs {
    dependencies = with self; [ vim-misc ];
    patches = [
      (fetchpatch {
        # https://github.com/xolox/vim-easytags/pull/170 fix version detection for universal-ctags
        url = "https://github.com/xolox/vim-easytags/commit/46e4709500ba3b8e6cf3e90aeb95736b19e49be9.patch";
        sha256 = "0x0xabb56xkgdqrg1mpvhbi3yw4d829n73lsnnyj5yrxjffy4ax4";
      })
    ];
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
        # TODO: package commented packages
        asmfmt
        delve
        errcheck
        go-motion
        go-tools # contains staticcheck
        gocode
        gocode-gomod
        godef
        gogetdoc
        golint
        golangci-lint
        gomodifytags
        gopls
        # gorename
        gotags
        gotools
        # guru
        iferr
        impl
        # keyify
        reftools
        # revive
      ];
    in
    super.vim-go.overrideAttrs {
      postPatch = ''
        sed -i autoload/go/config.vim -Ee 's@"go_bin_path", ""@"go_bin_path", "${binPath}"@g'
      '';
    };

  vim-gist = super.vim-gist.overrideAttrs {
    dependencies = with self; [ webapi-vim ];
  };

  vim-grammarous = super.vim-grammarous.overrideAttrs {
    # use `:GrammarousCheck` to initialize checking
    # In neovim, you also want to use set
    #   let g:grammarous#show_first_error = 1
    # see https://github.com/rhysd/vim-grammarous/issues/39
    patches = [
      (substituteAll {
        src = ./patches/vim-grammarous/set_default_languagetool.patch;
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

  vim-isort = super.vim-isort.overrideAttrs {
    postPatch = ''
      substituteInPlace ftplugin/python_vimisort.vim \
        --replace 'import vim' 'import vim; import sys; sys.path.append("${python3.pkgs.isort}/${python3.sitePackages}")'
    '';
  };

  vim-markdown-composer =
    let
      vim-markdown-composer-bin = rustPlatform.buildRustPackage {
        pname = "vim-markdown-composer-bin";
        inherit (super.vim-markdown-composer) src version;
        cargoSha256 = "sha256-Vie8vLTplhaVU4E9IohvxERfz3eBpd62m8/1Ukzk8e4=";
        # tests require network access
        doCheck = false;
      };
    in
    super.vim-markdown-composer.overrideAttrs {
      preFixup = ''
        substituteInPlace "$out"/after/ftplugin/markdown/composer.vim \
          --replace "s:plugin_root . '/target/release/markdown-composer'" \
          "'${vim-markdown-composer-bin}/bin/markdown-composer'"
      '';
    };

  vim-metamath = super.vim-metamath.overrideAttrs {
    preInstall = "cd vim";
  };

  vim-pluto = super.vim-pluto.overrideAttrs {
    dependencies = with self; [ denops-vim ];
  };

  vim-sensible = super.vim-sensible.overrideAttrs {
    patches = [ ./patches/vim-sensible/fix-nix-store-path-regex.patch ];
  };

  vim-snipmate = super.vim-snipmate.overrideAttrs {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  };

  vim-speeddating = super.vim-speeddating.overrideAttrs {
    dependencies = with self; [ vim-repeat ];
  };

  vim-stylish-haskell = super.vim-stylish-haskell.overrideAttrs (old: {
    postPatch =
      old.postPatch
        or ""
      + ''
        substituteInPlace ftplugin/haskell/stylish-haskell.vim --replace \
          'g:stylish_haskell_command = "stylish-haskell"' \
          'g:stylish_haskell_command = "${stylish-haskell}/bin/stylish-haskell"'
      '';
  });

  vim-surround = super.vim-surround.overrideAttrs {
    dependencies = with self; [ vim-repeat ];
  };

  vim-textobj-entire = super.vim-textobj-entire.overrideAttrs {
    dependencies = with self; [ vim-textobj-user ];
    meta.maintainers = with lib.maintainers; [ farlion ];
  };

  vim-unimpaired = super.vim-unimpaired.overrideAttrs {
    dependencies = with self; [ vim-repeat ];
  };

  vim-wakatime = super.vim-wakatime.overrideAttrs {
    buildInputs = [ python3 ];
    patchPhase = ''
      substituteInPlace plugin/wakatime.vim \
        --replace 'autocmd BufEnter,VimEnter' \
                  'autocmd VimEnter' \
        --replace 'autocmd CursorMoved,CursorMovedI' \
                  'autocmd CursorMoved,CursorMovedI,BufEnter'
    '';
  };

  vim-xdebug = super.vim-xdebug.overrideAttrs {
    postInstall = null;
  };

  vim-xkbswitch = super.vim-xkbswitch.overrideAttrs {
    patchPhase = ''
      substituteInPlace plugin/xkbswitch.vim \
        --replace /usr/local/lib/libxkbswitch.so ${xkb-switch}/lib/libxkbswitch.so
    '';
    buildInputs = [ xkb-switch ];
  };

  vim-yapf = super.vim-yapf.overrideAttrs {
    buildPhase = ''
      substituteInPlace ftplugin/python_yapf.vim \
        --replace '"yapf"' '"${python3.pkgs.yapf}/bin/yapf"'
    '';
  };

  vim2nix = buildVimPlugin {
    pname = "vim2nix";
    version = "1.0";
    src = ./vim2nix;
    dependencies = with self; [ vim-addon-manager ];
  };

  vimacs = super.vimacs.overrideAttrs {
    buildPhase = ''
      substituteInPlace bin/vim \
        --replace '/usr/bin/vim' 'vim' \
        --replace '/usr/bin/gvim' 'gvim'
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

    buildPhase = ''
      substituteInPlace autoload/vimproc.vim \
        --replace vimproc_mac.so vimproc_unix.so \
        --replace vimproc_linux64.so vimproc_unix.so \
        --replace vimproc_linux32.so vimproc_unix.so
      make -f make_unix.mak
    '';
  };

  vimshell-vim = super.vimshell-vim.overrideAttrs {
    dependencies = with self; [ vimproc-vim ];
  };

  vim-zettel = super.vim-zettel.overrideAttrs {
    dependencies = with self; [ vimwiki fzf-vim ];
  };

  wtf-nvim = super.wtf-nvim.overrideAttrs {
    dependencies = with self; [ nui-nvim ];
  };

  YankRing-vim = super.YankRing-vim.overrideAttrs {
    sourceRoot = ".";
  };

  YouCompleteMe = super.YouCompleteMe.overrideAttrs {
    buildPhase = ''
      substituteInPlace plugin/youcompleteme.vim \
        --replace "'ycm_path_to_python_interpreter', '''" \
        "'ycm_path_to_python_interpreter', '${python3}/bin/python3'"

      rm -r third_party/ycmd
      ln -s ${ycmd}/lib/ycmd third_party
    '';

    meta = with lib; {
      description = "A code-completion engine for Vim";
      homepage = "https://github.com/Valloric/YouCompleteMe";
      license = licenses.gpl3;
      maintainers = with maintainers; [ marcweber jagajaga ];
      platforms = platforms.unix;
    };
  };

  zoxide-vim = super.zoxide-vim.overrideAttrs {
    buildInputs = [ zoxide ];

    postPatch = ''
      substituteInPlace autoload/zoxide.vim \
        --replace "'zoxide_executable', 'zoxide'" "'zoxide_executable', '${zoxide}/bin/zoxide'"
    '';
  };
  LeaderF = super.LeaderF.overrideAttrs {
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
}
  // (
  let
    nodePackageNames = [
      "coc-clangd"
      "coc-cmake"
      "coc-css"
      "coc-diagnostic"
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
      "coc-metals"
      "coc-pairs"
      "coc-prettier"
      "coc-pyright"
      "coc-python"
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
      "coc-toml"
      "coc-tslint"
      "coc-tslint-plugin"
      "coc-tsserver"
      "coc-ultisnips"
      "coc-vetur"
      "coc-vimlsp"
      "coc-vimtex"
      "coc-wxml"
      "coc-yaml"
      "coc-yank"
    ];
    nodePackage2VimPackage = name:
      buildVimPlugin {
        pname = name;
        inherit (nodePackages.${name}) version meta;
        src = "${nodePackages.${name}}/lib/node_modules/${name}";
      };
  in
  lib.genAttrs nodePackageNames nodePackage2VimPackage
)
