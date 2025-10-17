{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  libGL,
  fontconfig,
  openssl,
  poppler,
  ffmpeg,
  libva,
  alsa-lib,
  SDL,
  x264,
  libvpx,
  libvorbis,
  libtheora,
  libogg,
  libopus,
  lame,
  fdk_aac,
  libass,
  libXext,
  libXfixes,
}:

let
  inherit (qt6Packages)
    qtbase
    qttools
    qtmultimedia
    qtwebengine
    qmake
    wrapQtAppsHook
    quazip
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openboard";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "OpenBoard-org";
    repo = "OpenBoard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Igp5WSVQ9FrzS2AhDDPwVBo76SaFw9xP6lqgW7S/KIE=";
  };

  postPatch = ''
    substituteInPlace resources/etc/OpenBoard.config \
      --replace-fail 'EnableAutomaticSoftwareUpdates=true' 'EnableAutomaticSoftwareUpdates=false' \
      --replace-fail 'EnableSoftwareUpdates=true' 'EnableAutomaticSoftwareUpdates=false' \
      --replace-fail 'HideCheckForSoftwareUpdate=false' 'HideCheckForSoftwareUpdate=true'
  '';

  # Required by Poppler
  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
    qtwebengine
    qtmultimedia
    libGL
    fontconfig
    openssl
    poppler
    ffmpeg
    libva
    alsa-lib
    SDL
    x264
    libvpx
    libvorbis
    libtheora
    libogg
    libopus
    lame
    fdk_aac
    libass
    quazip
    libXext
    libXfixes
  ];

  meta = with lib; {
    description = "Interactive whiteboard application";
    homepage = "https://openboard.ch/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      atinba
      fufexan
    ];
    platforms = platforms.linux;
    mainProgram = "openboard";
  };
})
