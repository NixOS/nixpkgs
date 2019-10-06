{ stdenv, fetchFromGitHub, mkDerivation
, qtbase, qtsvg, qtserialport, qtwebkit, qtmultimedia, qttools
, qtconnectivity, qtcharts
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
in mkDerivation rec {
  pname = "golden-cheetah";
  version = "3.5-DEV1903";

  src = fetchFromGitHub {
    owner = "GoldenCheetah";
    repo = "GoldenCheetah";
    rev = "v${version}";
    sha256 = "130b0hm04i0hf97rs1xrdfhbal5vjsknj3x4cdxjh7rgbg2p1sm3";
  };

  buildInputs = [
    qtbase qtsvg qtserialport qtwebkit qtmultimedia qttools zlib
    qtconnectivity qtcharts
  ];
  nativeBuildInputs = [ flex makeWrapper qmake yacc ];

  NIX_LDFLAGS = [ "-lz" ];

  qtWrapperArgs = [ "--set LD_LIBRARY_PATH ${zlib.out}/lib" ];

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
