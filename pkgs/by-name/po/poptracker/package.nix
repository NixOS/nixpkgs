{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  libX11,
  openssl,
  zlib,
  which,
  kdePackages,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poptracker";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "black-sliver";
    repo = "PopTracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DFJfuDOzcVdiXLv5EzO5TL3UJLCZPM1bTZharp2ww5U=";
    fetchSubmodules = true;
  };

  passthru.updateScript = nix-update-script { };

  patches = [ ./assets-path.diff ];

  postPatch = ''
    substituteInPlace src/poptracker.cpp --replace "@assets@" "$out/share/poptracker/"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    util-linux
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    libX11
    openssl
    zlib
  ];

  buildFlags = [
    "native"
    "CONF=RELEASE"
    "VERSION=v${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin build/linux-x86_64/poptracker
    install -m444 -Dt $out/share/poptracker assets/*
    wrapProgram $out/bin/poptracker --prefix PATH : ${
      lib.makeBinPath [
        which
        kdePackages.kdialog
      ]
    }
    mkdir -p $out/share/icons/hicolor/{64x64,512x512}/apps
    ln -s $out/share/poptracker/icon.png  $out/share/icons/hicolor/64x64/apps/poptracker.png
    ln -s $out/share/poptracker/icon512.png  $out/share/icons/hicolor/512x512/apps/poptracker.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "poptracker";
      desktopName = "PopTracker";
      exec = "poptracker";
      comment = "Universal, scriptable randomizer tracking solution";
      icon = "poptracker";
      categories = [
        "Game"
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Scriptable tracker for randomized games";
    longDescription = ''
      Universal, scriptable randomizer tracking solution that is open source. Supports auto-tracking.

      PopTracker packs should be placed in `~/PopTracker/packs` or `./packs`.
    '';
    homepage = "https://github.com/black-sliver/PopTracker";
    changelog = "https://github.com/black-sliver/PopTracker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      freyacodes
      pyrox0
    ];
    mainProgram = "poptracker";
    platforms = [ "x86_64-linux" ];
  };
})
