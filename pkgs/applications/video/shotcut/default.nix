{ stdenv, fetchFromGitHub, fetchpatch, mkDerivation, SDL2, frei0r, gettext, mlt
, jack1, pkgconfig, qtbase, qtmultimedia, qtwebkit, qtx11extras, qtwebsockets
, qtquickcontrols, qtgraphicaleffects, libmlt, qmake, qttools, genericUpdater
, common-updater-scripts
}:

assert stdenv.lib.versionAtLeast libmlt.version "6.22.1";
assert stdenv.lib.versionAtLeast mlt.version "6.22.1";

mkDerivation rec {
  pname = "shotcut";
  version = "20.10.31";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    rev = "v${version}";
    sha256 = "16ypq1v396pibhh33nm78p6hr5fz3h74l0ykg9f72b8whw23jyz6";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    SDL2 frei0r gettext mlt libmlt
    qtbase qtmultimedia qtwebkit qtx11extras qtwebsockets qtquickcontrols
    qtgraphicaleffects
  ];

  NIX_CFLAGS_COMPILE = "-I${libmlt}/include/mlt++ -I${libmlt}/include/mlt";
  qmakeFlags = [
    "QMAKE_LRELEASE=${stdenv.lib.getDev qttools}/bin/lrelease"
    "SHOTCUT_VERSION=${version}"
    "DEFINES+=SHOTCUT_NOUPGRADE"
  ];

  prePatch = ''
    sed 's_shotcutPath, "qmelt"_"${mlt}/bin/melt"_' -i src/jobs/meltjob.cpp
    sed 's_shotcutPath, "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/jobs/ffmpegjob.cpp
    sed 's_qApp->applicationDirPath(), "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/docks/encodedock.cpp
    NICE=$(type -P nice)
    sed "s_/usr/bin/nice_''${NICE}_" -i src/jobs/meltjob.cpp src/jobs/ffmpegjob.cpp
  '';

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [jack1 SDL2]}"
    "--prefix PATH : ${mlt}/bin"
    ];

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
  '';

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
    rev-prefix = "v";
  };

  meta = with stdenv.lib; {
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu woffs peti ];
    platforms = platforms.linux;
  };
}
