{
  lib,
  stdenv,

  R,
  bison,
  blas,
  fetchFromGitHub,
  flex,
  gsl,
  libusb-compat-0_1,
  makeDesktopItem,
  nix-update-script,
  rPackages,
  qt6,
  zlib,
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
in
stdenv.mkDerivation rec {
  pname = "golden-cheetah";
  version = "3.7-DEV2412";

  src = fetchFromGitHub {
    owner = "GoldenCheetah";
    repo = "GoldenCheetah";
    rev = "refs/tags/v${version}";
    hash = "sha256-0T0AK3j8R58CXkzt/ee/pTR2AxzD1ZFtO3glz/P9Z8E=";
  };

  buildInputs = [
    blas
    gsl
    libusb-compat-0_1
    qt6.qmake
    qt6.qt5compat
    qt6.qtbase
    qt6.qtcharts
    qt6.qtconnectivity
    qt6.qtmultimedia
    qt6.qtserialport
    qt6.qtsvg
    qt6.qttools
    qt6.qtwebengine
    zlib

    R
    rPackages.RInside
    rPackages.Rcpp
  ];

  nativeBuildInputs = [
    bison
    flex
    qt6.wrapQtAppsHook
  ];

  NIX_LDFLAGS = "-lz -lgsl -lblas";

  qtWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${zlib.out}/lib"
  ];

  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    sed -i 's,^#QMAKE_LRELEASE.*,QMAKE_LRELEASE = ${qt6.qttools.dev}/bin/lrelease,' src/gcconfig.pri
    sed -i 's,^#LIBUSB_INSTALL.*,LIBUSB_INSTALL = ${libusb-compat-0_1},' src/gcconfig.pri
    sed -i 's,^#LIBUSB_INCLUDE.*,LIBUSB_INCLUDE = ${libusb-compat-0_1.dev}/include,' src/gcconfig.pri
    sed -i 's,^#LIBUSB_LIBS.*,LIBUSB_LIBS = -L${libusb-compat-0_1}/lib -lusb,' src/gcconfig.pri
    sed -i 's,#\(DEFINES += GC_WANT_R.*\),\1 ,' src/gcconfig.pri
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ls
    ls src/
    cp src/GoldenCheetah $out/bin
    install -Dm644 "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -Dm644 src/Resources/images/gc.png $out/share/pixmaps/goldencheetah.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Performance software for cyclists, runners and triathletes. Built from source and without API tokens";
    mainProgram = "GoldenCheetah";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ adamcstephens ];
    license = lib.licenses.gpl2Plus;
  };
}
