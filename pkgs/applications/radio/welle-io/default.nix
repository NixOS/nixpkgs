{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  qtcharts,
  qtmultimedia,
  qtdeclarative,
  qt5compat,
  faad2,
  rtl-sdr,
  soapysdr-with-plugins,
  libusb-compat-0_1,
  fftwSinglePrec,
  lame,
  mpg123,
  withFlac ? true,
  flac,
}:

stdenv.mkDerivation rec {
  pname = "welle-io";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "v${version}";
    hash = "sha256-sSknzZiD9/MLyO+gAYopogOQu5HRcqaRcfqwq4Rld7A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    faad2
    fftwSinglePrec
    lame
    libusb-compat-0_1
    mpg123
    qtbase
    qtcharts
    qtmultimedia
    qt5compat
    rtl-sdr
    soapysdr-with-plugins
  ] ++ lib.optional withFlac flac;

  cmakeFlags = [
    "-DRTLSDR=true"
    "-DSOAPYSDR=true"
  ] ++ lib.optional withFlac "-DFLAC=true";

  meta = {
    description = "DAB/DAB+ Software Radio";
    homepage = "https://www.welle.io/";
    maintainers = with lib.maintainers; [
      ck3d
      markuskowa
    ];
    license = lib.licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ] ++ lib.platforms.darwin;
  };
}
