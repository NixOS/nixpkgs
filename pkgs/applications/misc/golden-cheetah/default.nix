{ stdenv, fetchFromGitHub, mkDerivation
, qtbase, qtsvg, qtserialport, qtwebengine, qtmultimedia, qttools
, qtconnectivity, qtcharts, libusb
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
  version = "3.5-RC2X";

  src = fetchFromGitHub {
    owner = "GoldenCheetah";
    repo = "GoldenCheetah";
    rev = "V${version}";
    sha256 = "1d85700gjbcw2badwz225rjdr954ai89900vp8sal04sk79wbr6g";
  };

  buildInputs = [
    qtbase qtsvg qtserialport qtwebengine qtmultimedia qttools zlib
    qtconnectivity qtcharts libusb
  ];
  nativeBuildInputs = [ flex makeWrapper qmake yacc ];

  NIX_LDFLAGS = "-lz";

  qtWrapperArgs = [ "--set LD_LIBRARY_PATH ${zlib.out}/lib" ];

  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    echo 'QMAKE_LRELEASE = ${qttools.dev}/bin/lrelease' >> src/gcconfig.pri
    echo 'LIBUSB_INSTALL = ${libusb}' >> src/gcconfig.pri
    echo 'LIBUSB_INCLUDE = ${libusb.dev}/include' >> src/gcconfig.pri
    echo 'LIBUSB_LIBS = -L${libusb}/lib -lusb' >> src/gcconfig.pri
    sed -i -e '21,23d' qwt/qwtconfig.pri # Removed forced installation to /usr/local

    # Use qtwebengine instead of qtwebkit
    substituteInPlace src/gcconfig.pri \
      --replace "#DEFINES += NOWEBKIT" "DEFINES += NOWEBKIT"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/GoldenCheetah $out/bin
    install -Dm644 "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -Dm644 src/Resources/images/gc.png $out/share/pixmaps/goldencheetah.png

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Performance software for cyclists, runners and triathletes";
    platforms = platforms.linux;
    maintainers = [ maintainers.ocharles ];
    license = licenses.gpl3;
  };
}
