{ stdenv, fetchurl
, qtbase, qtsvg, qtserialport, qtwebkit, qtmultimedia, qttools, qtconnectivity
, yacc, flex, zlib, qmake, makeDesktopItem, makeWrapper
}:

let
  desktopItem = makeDesktopItem {
    name = "goldencheetah";
    exec = "GoldenCheetah";
    icon = "goldencheetah";
    desktopName = "GoldenCheetah";
    genericName = "GoldenCheetah";
    comment = "Performance software for cyclists, runners and triathletes";
    categories = "Application;Utility;";
  };
in stdenv.mkDerivation rec {
  name = "golden-cheetah-${version}";
  version = "3.5-DEV1903";
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/GoldenCheetah/GoldenCheetah/archive/v${version}.tar.gz";
    sha256 = "1042q5yh6k4m9hiyapz10bmg5jwa6s1hy086mq0768wybiqzilb2";
  };
  buildInputs = [
    qtbase qtsvg qtserialport qtwebkit qtmultimedia qttools zlib
    qtconnectivity
  ];
  nativeBuildInputs = [ flex makeWrapper qmake yacc ];
  NIX_LDFLAGS = [
    "-lz"
  ];
  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    echo 'QMAKE_LRELEASE = ${qttools.dev}/bin/lrelease' >> src/gcconfig.pri
    sed -i -e '21,23d' qwt/qwtconfig.pri # Removed forced installation to /usr/local
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/GoldenCheetah $out/bin
    wrapProgram $out/bin/GoldenCheetah --set LD_LIBRARY_PATH "${zlib.out}/lib"
    install -Dm644 "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -Dm644 src/Resources/images/gc.png $out/share/pixmaps/goldencheetah.png

    runHook postInstall
  '';

  # RCC: Error in 'Resources/application.qrc': Cannot find file 'translations/gc_fr.qm'
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Performance software for cyclists, runners and triathletes";
    platforms = platforms.linux;
    maintainers = [ maintainers.ocharles ];
    license = licenses.gpl3;
  };
}
