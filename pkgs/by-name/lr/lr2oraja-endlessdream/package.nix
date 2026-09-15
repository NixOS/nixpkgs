{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchzip,
  copyDesktopItems,
  makeBinaryWrapper,
  makeDesktopItem,
  writeShellScriptBin,
  lr2oraja-endlessdream-unwrapped,
}:
let
  assets = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "beatoraja-assets";
    version = "0.8.8";
    src = fetchzip {
      url = "https://mocha-repository.info/download/beatoraja${finalAttrs.version}-modernchic.zip";
      hash = "sha256-TujfJ7hgjEKs5NbGvwo3/nkbJFvcZ4mefgkdp6oQHw4=";
    };
    installPhase = ''
      mkdir -p $out
      find . -type f \( \
        -name "*.bat" \
        -or -name "*.command" \
        -or -name "*.dll" \
        -or -name "beatoraja.jar" \) \
        -exec rm {} +
      rm skin/ModernChic/History/*.txt
      cp -r * $out
    '';
  });
  launcher = writeShellScriptBin "lr2oraja-endlessdream-launcher" ''
    runDir=''${XDG_DATA_HOME:-$HOME/.local/share}/lr2oraja-endlessdream
    linkGameFiles() {
      mkdir -p "$runDir"
      cp -rs ${assets}/* "$runDir"
      chmod -R u=rwX,g=rX,o= "$runDir"
    }
    if [[ ! -d $runDir ]]; then
      echo "Game directory $runDir not found. Assuming first launch"
      echo "Linking game files"
      linkGameFiles
    fi
    cd "$runDir"
    exec ${lib.getExe lr2oraja-endlessdream-unwrapped}
  '';
in
stdenvNoCC.mkDerivation {
  name = "lr2oraja-endlessdream";

  src = "/dev/null";

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "lr2oraja-endlessdream";
      desktopName = "LR2oraja ~Endless Dream~";
      genericName = "BMS player/Rhythm game";
      comment = lr2oraja-endlessdream-unwrapped.meta.description;
      icon = fetchurl {
        name = "lr2oraja-endlessdream-icon.png";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/lr2oraja-endlessdream-icon.png?h=lr2oraja-endlessdream&id=9b4c189231f7738642de530f1ec54a2c00168a74";
        hash = "sha256-/b03/0OqavIPnrZDvycad+9XkBSXCno9zs945lEj2D0=";
      };
      exec = "lr2oraja-endlessdream-launcher";
      categories = [
        "Game"
        "ArcadeGame"
      ];
      keywords = [
        "beatmania"
        "beatoraja"
        "bemani"
        "bms"
        "iidx"
        "konami"
        "rhythm"
      ];
      singleMainWindow = true;
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${lib.getExe launcher} $out/bin
    runHook postInstall
  '';

  meta = lr2oraja-endlessdream-unwrapped.meta // {
    mainProgram = "lr2oraja-endlessdream-launcher";
  };
}
