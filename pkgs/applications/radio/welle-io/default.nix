{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  qtcharts,
  qtmultimedia,
  qt5compat,
  faad2,
  rtl-sdr,
  soapysdr-with-plugins,
  libusb-compat-0_1,
  fftwSinglePrec,
  lame,
  mpg123,
  unixtools,
  withFlac ? true,
  flac,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "welle-io";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+xjwvxFrv++XF6Uhm/ZwkseuToz3LtqCfTD18GiwNyw=";
  };

  patches = [
    # https://github.com/AlbrechtL/welle.io/pull/853
    (fetchpatch {
      name = "cmake3_16.patch";
      url = "https://github.com/AlbrechtL/welle.io/commit/c7581c251b5fe2408b45365e0f2c5efc7f01fd19.patch";
      hash = "sha256-e282lwCstwsRFGCtFT39CBn1jTvkA9bxa5t6Nk8mc98=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    unixtools.xxd
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
  ]
  ++ lib.optional withFlac flac;

  cmakeFlags = [
    "-DRTLSDR=true"
    "-DSOAPYSDR=true"
  ]
  ++ lib.optional withFlac "-DFLAC=true";

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
    ]
    ++ lib.platforms.darwin;
  };
})
