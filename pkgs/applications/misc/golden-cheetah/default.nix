{ stdenv, fetchurl, qtbase, qtsvg, qtserialport, qtwebkit, qtmultimedia
, qttools, yacc, flex, zlib, config, qmakeHook, makeQtWrapper }:
stdenv.mkDerivation rec {
  name = "golden-cheetah-${version}";
  version = "V4.0-DEV1603";
  src = fetchurl {
    url = "https://github.com/GoldenCheetah/GoldenCheetah/archive/${version}.tar.gz";
    sha256 = "12knlzqmq8b3nyl3kvcsnzrbjksgd83mzwzj97wccyfiffjl4wah";
  };
  buildInputs = [
    qtbase qtsvg qtserialport qtwebkit qtmultimedia qttools yacc flex zlib
  ];
  nativeBuildInputs = [ makeQtWrapper qmakeHook ];
  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    echo 'QMAKE_LRELEASE = ${qttools}/bin/lrelease' >> src/gcconfig.pri
    sed -i -e '21,23d' qwt/qwtconfig.pri # Removed forced installation to /usr/local
  '';
  #postConfigure =
    #  + (
    # with (config.golden-cheetah);
    # stdenv.lib.optionalString (dropbox-client-id != null && dropbox-client-secret != null) ''
    #   echo 'DEFINES += GC_DROPBOX_CLIENT_ID=\\\"${config.golden-cheetah.dropbox-client-id}\\\"' >>  src/gcconfig.pri
    #   echo 'DEFINES += GC_DROPBOX_CLIENT_SECRET=\\\"${config.golden-cheetah.dropbox-client-secret}\\\"' >>  src/gcconfig.pri
    # '');
  installPhase = ''
    mkdir -p $out/bin
    cp src/GoldenCheetah $out/bin
    wrapQtProgram $out/bin/GoldenCheetah --set LD_LIBRARY_PATH "${zlib.out}/lib" # patchelf doesn't seem to work
  '';
  meta = {
    description = "Performance software for cyclists, runners and triathletes";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
