{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  qt6Packages,
  libGL,
  gtk3,
  libx11,
  zlib,
}:
let
  runtimeLibs = [
    libGL
  ];

  # The zip ships no app icon, so use the official logo from the
  # cheat-engine repo, pinned to a commit for reproducibility.
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/cheat-engine/cheat-engine/ec45d5f47f92a239ba0bf51ec5d04a7509c3fd37/Cheat%20Engine/images/celogo.png";
    sha256 = "sha256-MNq3cEvgjE7Jl5isoajMTt2CutdjuvwKidZdM0aYFuo=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "cheat-engine";
  version = "7.7.1";

  src = fetchurl {
    url = "https://cheatengine.org/download/CheatEngineLinux771.zip";
    hash = "sha256-D7DZBDroVqzeA7W4caLzYn689nSurNBF+G1W2RoH8Xc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    copyDesktopItems
    makeWrapper

    wrapGAppsHook3
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    gtk3
    qt6Packages.qtbase
    qt6Packages.libqtpas
    libx11
    libGL
    zlib
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "cheat-engine";
      exec = "cheat-engine";
      icon = "cheat-engine";
      desktopName = "Cheat Engine";
      comment = "Memory scanner/debugger for games";
      categories = [
        "Game"
        "Utility"
      ];
    })
  ];

  dontBuild = true;
  dontConfigure = true;
  dontWrapGApps = true;
  dontWrapQtApps = true;

  unpackPhase = ''
    unzip -q "$src"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cheat-engine $out/bin
    cp -r ./* $out/share/cheat-engine/
    install -Dm644 ${icon} $out/share/icons/hicolor/128x128/apps/cheat-engine.png

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper \
      $out/share/cheat-engine/cheatengine-x86_64 \
      $out/bin/cheat-engine \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
      --chdir $out/share/cheat-engine
  '';

  # No GitHub/GitLab/etc. release source nix-update can check, so this ships
  # a custom script that reads the version off the downloads page.
  passthru.updateScript = [ ./update.sh ];

  meta = {
    description = "Memory scanner/debugger for games, used for educational purposes";
    homepage = "https://cheatengine.org/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.linux;
    mainProgram = "cheat-engine";
    maintainers = [ lib.maintainers.mschuwalow ];
  };
}
