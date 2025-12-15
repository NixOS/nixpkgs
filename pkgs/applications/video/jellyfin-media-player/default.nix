{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  qtwebchannel,
  qtwebengine,
  mpvqt,
  libcec,
  SDL2,
  libXrandr,
}:
stdenv.mkDerivation rec {
  pname = "jellyfin-media-player";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-media-player";
    rev = "v${version}";
    hash = "sha256-tdjmOeuC3LFEIDSH8X9LG/myvE1FoxwR1zpDQRyaTkQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtwebchannel
    qtwebengine

    mpvqt

    # input sources
    libcec
    SDL2

    # frame rate switching
    libXrandr
  ];

  cmakeFlags = [
    "-DCHECK_FOR_UPDATES=OFF"
    "-DUSE_STATIC_MPVQT=OFF"
    # workaround for Qt cmake weirdness
    "-DQT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES=ON"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    mv "$out/Jellyfin Media Player.app" $out/Applications
    ln -s "$out/Applications/Jellyfin Media Player.app/Contents/MacOS/Jellyfin Media Player" $out/bin/jellyfinmediaplayer
  '';

  meta = {
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    description = "Jellyfin Desktop Client";
    license = with lib.licenses; [
      gpl2Only
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      jojosch
      kranzes
      paumr
    ];
    mainProgram = "jellyfinmediaplayer";
  };
}
