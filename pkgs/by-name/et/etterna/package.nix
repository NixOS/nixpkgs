{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  # deps
  cmake,
  pkg-config,
  openssl,
  libGLU,
  xorg,
  alsa-lib,
  libjack2,
  libpulseaudio,
  libogg,
  sse2neon,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "etterna";
  version = "0.74.4";

  src = fetchFromGitHub {
    owner = "etternagame";
    repo = "etterna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZCQt99Qcov/7jGfrSmX9WftaP2U2B1d1APK1mxrUDBs=";
  };

  patches = [ ./fix-download-manager.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config

    copyDesktopItems
  ];

  buildInputs = [
    openssl
    alsa-lib
    libjack2
    libpulseaudio
    libGLU
    libogg
    sse2neon
    xorg.libXinerama
    xorg.libXrandr
    xorg.libX11
    xorg.libXext # Needed for DPMS
    xorg.libXvMC
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "etterna";
      desktopName = "Etterna";
      genericName = "Rhythm and dance game";
      icon = "etterna";
      tryExec = "etterna";
      exec = "etterna";
      categories = [
        "Application"
        "Game"
        "ArcadeGame"
      ];
      comment = "A cross-platform rhythm video game.";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/etterna}
    mkdir -p $out/share/applications
    # copy select necessary game files into virtual fs
    cp -r /build/source/{Announcers,Assets,BGAnimations,BackgroundEffects,BackgroundTransitions,Data,GameTools,NoteSkins,Scripts,Themes} "$out/share/etterna"

    # copy binary
    cp /build/source/Etterna $out/bin/.etterna-unwrapped

    # Install the Icon
    install -Dm644 /build/source/Docs/images/etterna-logo-light.svg "$out/share/icons/hicolor/scalable/apps/etterna.svg"

    # wacky insertion of wrapper directly into phase, so that $out is set
    cat > $out/bin/etterna << EOF
    #!${stdenv.shell}
    export ETTERNA_ROOT_DIR="\$HOME/.local/share/etterna"
    export ETTERNA_ADDITIONAL_ROOT_DIRS="$out/share/etterna"
    echo "HOME: \$HOME"
    echo "PWD: \$(pwd)"
    echo "ETTERNA_ADDITIONAL_ROOT_DIRS: \$ETTERNA_ADDITIONAL_ROOT_DIRS"
    exec $out/bin/.etterna-unwrapped "\$@"
    EOF
    chmod +x $out/bin/etterna
    runHook postInstall
  '';

  cmakeFlags = [ "-D WITH_CRASHPAD=OFF" ];

  meta = {
    description = "Advanced cross-platform rhythm game focused on keyboard play";
    homepage = "https://etternaonline.com";
    changelog = "https://github.com/etternagame/etterna/release/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alikindsys ];
    mainProgram = "etterna";
  };
})
