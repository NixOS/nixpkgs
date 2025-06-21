{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
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
  importer = stdenv.mkDerivation {
    pname = "openboard-importer";
    version = "unstable-2016-10-08";

    src = fetchFromGitHub {
      owner = "OpenBoard-org";
      repo = "OpenBoard-Importer";
      rev = "47927bda021b4f7f1540b794825fb0d601875e79";
      sha256 = "19zhgsimy0f070caikc4vrrqyc8kv2h6rl37sy3iggks8z0g98gf";
    };

    nativeBuildInputs = [
      libsForQt5.qmake
      libsForQt5.wrapQtAppsHook
    ];
    buildInputs = [ libsForQt5.qtbase ];
    dontWrapQtApps = true;

    installPhase = ''
      install -Dm755 OpenBoardImporter $out/bin/OpenBoardImporter
    '';
  };
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
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtxmlpatterns
    libsForQt5.qttools
    libsForQt5.qtwebengine
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
    libsForQt5.quazip
    libXext
    libXfixes
  ];

  propagatedBuildInputs = [ importer ];

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
