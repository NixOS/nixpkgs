{ lib
, fetchFromGitHub
, stdenv
, wrapQtAppsHook
, substituteAll
, SDL2
, frei0r
, ladspaPlugins
, gettext
, mlt
, jack1
, pkg-config
, fftw
, qtbase
, qttools
, qtmultimedia
, qtcharts
, cmake
, gitUpdater
}:
stdenv.mkDerivation rec {
  pname = "shotcut";
  version = "23.12.15";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    rev = "v${version}";
    hash = "sha256-wTFnf7YMFzFI+buAI2Cqy7+cfcdDS0O1vAwiIZZKWhU=";
  };

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook ];
  buildInputs = [
    SDL2
    frei0r
    ladspaPlugins
    gettext
    mlt
    fftw
    qtbase
    qttools
    qtmultimedia
    qtcharts
  ];

  env.NIX_CFLAGS_COMPILE = "-DSHOTCUT_NOUPGRADE";
  cmakeFlags = [
    "-DSHOTCUT_VERSION=${version}"
  ];

  patches = [
    (substituteAll { inherit mlt; src = ./fix-mlt-ffmpeg-path.patch; })
  ];

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
    "--set LADSPA_PATH ${ladspaPlugins}/lib/ladspa"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [jack1 SDL2]}"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "A free, open source, cross-platform video editor";
    longDescription = ''
      An official binary for Shotcut, which includes all the
      dependencies pinned to specific versions, is provided on
      http://shotcut.org.

      If you encounter problems with this version, please contact the
      nixpkgs maintainer(s). If you wish to report any bugs upstream,
      please use the official build from shotcut.org instead.
    '';
    homepage = "https://shotcut.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ goibhniu woffs peti ];
    platforms = platforms.linux;
    mainProgram = "shotcut";
  };
}
