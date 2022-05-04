{ lib, fetchFromGitHub, fetchpatch, mkDerivation
, qtbase, qtsvg, qtserialport, qtwebengine, qtmultimedia, qttools
, qtconnectivity, qtcharts, libusb-compat-0_1, gsl, blas
, bison, flex, zlib, qmake, makeDesktopItem, makeWrapper
}:

let
  desktopItem = makeDesktopItem {
    name = "goldencheetah";
    exec = "GoldenCheetah";
    icon = "goldencheetah";
    desktopName = "GoldenCheetah";
    genericName = "GoldenCheetah";
    comment = "Performance software for cyclists, runners and triathletes";
    categories = [ "Utility" ];
  };
in mkDerivation rec {
  pname = "golden-cheetah";
  version = "3.6-DEV2111";

  src = fetchFromGitHub {
    owner = "GoldenCheetah";
    repo = "GoldenCheetah";
    rev = "v${version}";
    sha256 = "17sk89szvaq31bcv6rgfn1bbw132k7w8zlalfb3ayflavdxbk6sa";
  };

  buildInputs = [
    qtbase
    qtsvg
    qtserialport
    qtwebengine
    qtmultimedia
    qttools
    zlib
    qtconnectivity
    qtcharts
    libusb-compat-0_1
    gsl
    blas
  ];
  nativeBuildInputs = [ flex makeWrapper qmake bison ];

  patches = [
    # allow building with bison 3.7
    # Included in https://github.com/GoldenCheetah/GoldenCheetah/pull/3590,
    # which is periodically rebased but pre 3.6 release, as it'll break other CI systems
    ./0001-Fix-building-with-bison-3.7.patch
  ];

  NIX_LDFLAGS = "-lz -lgsl -lblas";

  qtWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" "${zlib.out}/lib" ];

  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    echo 'QMAKE_LRELEASE = ${qttools.dev}/bin/lrelease' >> src/gcconfig.pri
    echo 'LIBUSB_INSTALL = ${libusb-compat-0_1}' >> src/gcconfig.pri
    echo 'LIBUSB_INCLUDE = ${libusb-compat-0_1.dev}/include' >> src/gcconfig.pri
    echo 'LIBUSB_LIBS = -L${libusb-compat-0_1}/lib -lusb' >> src/gcconfig.pri
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

  meta = with lib; {
    description = "Performance software for cyclists, runners and triathletes";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.gpl2Plus;
  };
}
