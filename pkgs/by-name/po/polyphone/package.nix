{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  flac,
  libjack2,
  libogg,
  libvorbis,
  libsndfile,
  rtmidi,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.5.1";
  pname = "polyphone";

  src = fetchFromGitHub {
    owner = "davy7125";
    repo = "polyphone";
    tag = finalAttrs.version;
    hash = "sha256-zs8fdHC1/bR2m05+SEmsMPyxATE/KHcAj57DNYt63rQ=";
  };

  nativeBuildInputs = [
    pkg-config
    kdePackages.qmake
    kdePackages.qttools
    kdePackages.qtbase
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    flac
    libjack2
    libogg
    libvorbis
    libsndfile
    kdePackages.qtsvg
    kdePackages.qtwayland
    rtmidi
  ];

  preConfigure = ''
    cd ./sources/
  '';

  postConfigure = ''
    # Work around https://github.com/NixOS/nixpkgs/issues/214765
    substituteInPlace Makefile \
      --replace-fail "${lib.getBin kdePackages.qtbase}/bin/lrelease" "${lib.getBin kdePackages.qttools}/bin/lrelease"
  '';

  qmakeFlags = [
    "DEFINES+=USE_LOCAL_STK"
  ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Soundfont editor for creating musical instruments";
    mainProgram = "polyphone";
    homepage = "https://www.polyphone-soundfonts.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      maxdamantus
    ];
    platforms = lib.platforms.linux;
  };
})
