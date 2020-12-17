{ stdenv, fetchFromGitHub, fetchpatch, mkDerivation
, qtbase, qtsvg, qtserialport, qtwebengine, qtmultimedia, qttools
, qtconnectivity, qtcharts, libusb-compat-0_1
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
    categories = "Utility;";
  };
in mkDerivation rec {
  pname = "golden-cheetah";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "GoldenCheetah";
    repo = "GoldenCheetah";
    rev = "V${version}";
    sha256 = "1lyd0b2s3s9c2ppj7l4hf3s4gfzscaaam2pbiaby714bi9nr0ka7";
  };

  buildInputs = [
    qtbase qtsvg qtserialport qtwebengine qtmultimedia qttools zlib
    qtconnectivity qtcharts libusb-compat-0_1
  ];
  nativeBuildInputs = [ flex makeWrapper qmake yacc ];

  patches = [
    # allow building with bison 3.7
    # PR at https://github.com/GoldenCheetah/GoldenCheetah/pull/3590
    (fetchpatch {
      url = "https://github.com/GoldenCheetah/GoldenCheetah/commit/e1f42f8b3340eb4695ad73be764332e75b7bce90.patch";
      sha256 = "1h0y9vfji5jngqcpzxna5nnawxs77i1lrj44w8a72j0ah0sznivb";
    })
  ];

  NIX_LDFLAGS = "-lz";

  qtWrapperArgs = [ "--set LD_LIBRARY_PATH ${zlib.out}/lib" ];

  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    echo 'QMAKE_LRELEASE = ${qttools.dev}/bin/lrelease' >> src/gcconfig.pri
    echo 'LIBUSB_INSTALL = ${libusb-compat-0_1}' >> src/gcconfig.pri
    echo 'LIBUSB_INCLUDE = ${libusb-compat-0_1.dev}/include' >> src/gcconfig.pri
    echo 'LIBUSB_LIBS = -L${libusb-compat-0_1}/lib -lusb' >> src/gcconfig.pri
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
    maintainers = [ ];
    license = licenses.gpl3;
  };
}
