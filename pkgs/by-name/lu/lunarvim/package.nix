{ fd
, fetchFromGitHub
, fzf
, git
, lib
, makeWrapper
, neovim
, nodePackages
, python3
, ripgrep
, stdenv
, tree-sitter
}:
let
  lunar-python = python3.withPackages ( p: with p; [ pynvim ] );
  runtimeDeps = [
    fd
    fzf
    git
    neovim
    ripgrep
    lunar-python
    tree-sitter
    nodePackages.neovim
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lunarvim";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "LunarVim";
    repo = "LunarVim";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-z1Cw3wGpFDmlrAIy7rrjlMtzcW7a6HWSjI+asEDcGPA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out


    # Install required files
    export LUNARVIM_BASE_DIR="$out/base"
    mkdir $LUNARVIM_BASE_DIR
    cp init.lua $LUNARVIM_BASE_DIR
    cp -r {lua,snapshots} $LUNARVIM_BASE_DIR

    # Create laucher script

    ## Copy template to where the installer script expects it
    install -D ./utils/bin/lvim.template -t $LUNARVIM_BASE_DIR/utils/bin

    ## Required by the installer - will replace values in the template
    export INSTALL_PREFIX="$out"
    export XDG_DATA_HOME='"$HOME/.local/share"'
    export XDG_CACHE_HOME='"$HOME/.cache"'
    export XDG_CONFIG_HOME='"$HOME/.config"'

    bash ./utils/installer/install_bin.sh
    wrapProgram "$out/bin/lvim" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps }

    ## Remove the template after installation
    rm -rf $LUNARVIM_BASE_DIR/utils

    # Copy desktop icons
    ## They have to be in share/icons/WIDTHxHEIGHT/app/lvim.svg
    for formatFolder in utils/desktop/* ; do
      if ! [[ -d "$formatFolder" ]] ; then
        continue
      fi
      format=$(basename "$formatFolder")
      targetFormatFolder="$out/share/icons/hicolor/$format/apps"
      install -Dm444 "$formatFolder"/* -t "$targetFormatFolder"
    done

    # Create desktop launcher
    install -Dm444 utils/desktop/*.desktop -t $out/share/applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "An IDE layer for Neovim with sane defaults";
    homepage = "https://www.lunarvim.org/";
    changelog = "https://github.com/LunarVim/LunarVim/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ loveisgrief ];
    platforms = platforms.unix;
    mainProgram = "lvim";
  };
})
