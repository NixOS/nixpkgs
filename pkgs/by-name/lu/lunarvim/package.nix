{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, cargo
, curl
, fd
, fzf
, git
, gnumake
, gnused
, gnutar
, gzip
, lua-language-server
, neovim
, nodejs
, nodePackages
, ripgrep
, tree-sitter
, unzip
, nvimAlias ? false
, viAlias ? false
, vimAlias ? false
, globalConfig ? ""
}:

stdenv.mkDerivation (finalAttrs: {
  inherit nvimAlias viAlias vimAlias globalConfig;

  pname = "lunarvim";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "LunarVim";
    repo = "LunarVim";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-z1Cw3wGpFDmlrAIy7rrjlMtzcW7a6HWSjI+asEDcGPA=";
  };

  # Pull in the fix for Nerd Fonts until the next release
  patches = [
    (
      fetchpatch {
        url = "https://github.com/LunarVim/LunarVim/commit/d187cbd03fbc8bd1b59250869e0e325518bf8798.patch";
        sha256 = "sha256-ktkQ2GiIOhbVOMjy1u5Bf8dJP4SXHdG4j9OEFa9Fm7w=";
      }
    )
  ];

  nativeBuildInputs = [
    gnused
    makeWrapper
  ];

  runtimeDeps = [
    stdenv.cc
    cargo
    curl
    fd
    fzf
    git
    gnumake
    gnutar
    gzip
    lua-language-server
    neovim
    nodejs
    nodePackages.neovim
    ripgrep
    tree-sitter
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p share/lvim
    cp init.lua utils/installer/config.example.lua share/lvim
    cp -r lua snapshots share/lvim

    mkdir bin
    cp utils/bin/lvim.template bin/lvim
    chmod +x bin/lvim

    # LunarVim automatically copies config.example.lua, but we need to make it writable.
    sed -i "2 i\\
            if [ ! -f \$HOME/.config/lvim/config.lua ]; then \\
              cp $out/share/lvim/config.example.lua \$HOME/.config/lvim/config.lua \\
              chmod +w \$HOME/.config/lvim/config.lua \\
            fi
    " bin/lvim

    substituteInPlace bin/lvim \
      --replace NVIM_APPNAME_VAR lvim \
      --replace RUNTIME_DIR_VAR \$HOME/.local/share/lvim \
      --replace CONFIG_DIR_VAR \$HOME/.config/lvim \
      --replace CACHE_DIR_VAR \$HOME/.cache/lvim \
      --replace BASE_DIR_VAR $out/share/lvim \
      --replace nvim ${neovim}/bin/nvim

    # Allow language servers to be overridden by appending instead of prepending
    # the mason.nvim path.
    echo "lvim.builtin.mason.PATH = \"append\"" > share/lvim/global.lua
    echo ${ lib.strings.escapeShellArg finalAttrs.globalConfig } >> share/lvim/global.lua
    sed -i "s/add_to_path()/add_to_path(true)/" share/lvim/lua/lvim/core/mason.lua
    sed -i "/Log:set_level/idofile(\"$out/share/lvim/global.lua\")" share/lvim/lua/lvim/config/init.lua

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin share $out

    for iconDir in utils/desktop/*/; do
      install -Dm444 $iconDir/lvim.svg -t $out/share/icons/hicolor/$(basename $iconDir)/apps
    done

    install -Dm444 utils/desktop/lvim.desktop -t $out/share/applications

    wrapProgram $out/bin/lvim --prefix PATH : ${ lib.makeBinPath finalAttrs.runtimeDeps } \
      --prefix LD_LIBRARY_PATH : ${stdenv.cc.cc.lib} \
      --prefix CC : ${stdenv.cc.targetPrefix}cc
  '' + lib.optionalString finalAttrs.nvimAlias ''
    ln -s $out/bin/lvim $out/bin/nvim
  '' + lib.optionalString finalAttrs.viAlias ''
    ln -s $out/bin/lvim $out/bin/vi
  '' + lib.optionalString finalAttrs.vimAlias ''
    ln -s $out/bin/lvim $out/bin/vim
  '' + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "IDE layer for Neovim";
    homepage = "https://www.lunarvim.org/";
    changelog = "https://github.com/LunarVim/LunarVim/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prominentretail ];
    platforms = platforms.unix;
    mainProgram = "lvim";
  };
})
