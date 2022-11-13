{ lib
, cmake
, fetchFromGitHub
, mkDerivation
, SDL2
, fftw
, frei0r
, ladspaPlugins
, gettext
, mlt
, jack1
, pkg-config
, qtbase
, qtmultimedia
, qtx11extras
, qtwebsockets
, qtquickcontrols2
, qtgraphicaleffects
, qttools
, qttranslations
, gitUpdater
, wrapQtAppsHook
}:

assert lib.versionAtLeast mlt.version "7.6.0";

mkDerivation rec {
  pname = "shotcut";
  version = "22.10.25";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    rev = "v${version}";
    sha256 = "ldlKtOYIZcoRddYYT1YYRyn+EmqV/1w63b9WH1o6wYo=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    SDL2
    fftw
    frei0r
    ladspaPlugins
    gettext
    mlt
    qtbase
    qtmultimedia
    qttranslations
    qtx11extras
    qtwebsockets
    qtquickcontrols2
    qtgraphicaleffects
  ];

  prePatch = ''
    sed 's_shotcutPath, "melt[^"]*"_"${mlt}/bin/melt"_' -i src/jobs/meltjob.cpp src/mltcontroller.cpp
    sed 's_shotcutPath, "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/jobs/ffmpegjob.cpp
    sed 's_qApp->applicationDirPath(), "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/docks/encodedock.cpp src/widgets/directshowvideowidget.cpp
    sed 's_shotcutPath, "ffprobe"_"${mlt.ffmpeg}/bin/ffprobe"_' -i src/jobs/ffprobejob.cpp
    NICE=$(type -P nice)
    sed "s_/usr/bin/nice_''${NICE}_" -i src/jobs/meltjob.cpp src/jobs/ffmpegjob.cpp
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ jack1 SDL2 ]}"
  ];

  cmakeFlags = [
    "-DSHOTCUT_VERSION=${version}"
    "-DCMAKE_CXX_FLAGS=-DSHOTCUT_NOUPGRADE"
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
  };
}
