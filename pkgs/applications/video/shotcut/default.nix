{ lib
, fetchFromGitHub
, fetchpatch
, mkDerivation
, SDL2
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
, qmake
, qttools
, gitUpdater
}:

assert lib.versionAtLeast mlt.version "6.24.0";

mkDerivation rec {
  pname = "shotcut";
  version = "21.09.20";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    rev = "v${version}";
    sha256 = "1y46n5gmlayfl46l0vhg5g5dbbc0sg909mxb68sia0clkaas8xrh";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [
    SDL2
    frei0r
    ladspaPlugins
    gettext
    mlt
    qtbase
    qtmultimedia
    qtx11extras
    qtwebsockets
    qtquickcontrols2
    qtgraphicaleffects
  ];

  NIX_CFLAGS_COMPILE = "-I${mlt.dev}/include/mlt++ -I${mlt.dev}/include/mlt";
  qmakeFlags = [
    "QMAKE_LRELEASE=${lib.getDev qttools}/bin/lrelease"
    "SHOTCUT_VERSION=${version}"
    "DEFINES+=SHOTCUT_NOUPGRADE"
  ];

  prePatch = ''
    sed 's_shotcutPath, "melt[^"]*"_"${mlt}/bin/melt"_' -i src/jobs/meltjob.cpp
    sed 's_shotcutPath, "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/jobs/ffmpegjob.cpp
    sed 's_qApp->applicationDirPath(), "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/docks/encodedock.cpp
    NICE=$(type -P nice)
    sed "s_/usr/bin/nice_''${NICE}_" -i src/jobs/meltjob.cpp src/jobs/ffmpegjob.cpp
  '';

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ jack1 SDL2 ]}"
    "--prefix PATH : ${mlt}/bin"
  ];

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
  '';

  passthru.updateScript = gitUpdater {
    inherit pname version;
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
