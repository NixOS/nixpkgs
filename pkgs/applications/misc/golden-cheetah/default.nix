{ stdenv, fetchurl
, qtbase, qtsvg, qtserialport, qtwebkit, qtmultimedia, qttools, qtconnectivity
, yacc, flex, zlib, config, qmakeHook, makeQtWrapper
}:
stdenv.mkDerivation rec {
  name = "golden-cheetah-${version}";
  version = "3.4";
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/GoldenCheetah/GoldenCheetah/archive/V${version}.tar.gz";
    sha256 = "0fiz2pj155cd357kph50lc6rjyzwp045glfv4y68qls9j7m9ayaf";
  };
  qtInputs = [
    qtbase qtsvg qtserialport qtwebkit qtmultimedia qttools yacc flex zlib
    qtconnectivity
  ];
  nativeBuildInputs = [ makeQtWrapper qmakeHook ] ++ qtInputs;
  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    echo 'QMAKE_LRELEASE = ${qttools.dev}/bin/lrelease' >> src/gcconfig.pri
    sed -i -e '21,23d' qwt/qwtconfig.pri # Removed forced installation to /usr/local
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp src/GoldenCheetah $out/bin
    wrapQtProgram $out/bin/GoldenCheetah --set LD_LIBRARY_PATH "${zlib.out}/lib"
  '';
  meta = {
    description = "Performance software for cyclists, runners and triathletes";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
