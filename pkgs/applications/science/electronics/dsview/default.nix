{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  wrapQtAppsHook,
  libzip,
  boost,
  fftw,
  libusb1,
  qtbase,
  qtsvg,
  qtwayland,
  python3,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsview";

  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "DreamSourceLab";
    repo = "DSView";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-d/TfCuJzAM0WObOiBhgfsTirlvdROrlCm+oL1cqUrIs=";
  };

  patches = [
    # Fix absolute install paths
    ./install.patch
    ./cmake4.patch
  ];

  # /build/source/libsigrok4DSL/strutil.c:343:19: error: implicit declaration of function 'strcasecmp'; did you mean 'g_strcasecmp'? []
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    boost
    fftw
    qtbase
    qtsvg
    libusb1
    libzip
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux qtwayland;

  doInstallCheck = true;

  meta = {
    description = "GUI program for supporting various instruments from DreamSourceLab, including logic analyzer, oscilloscope, etc";
    mainProgram = "DSView";
    homepage = "https://www.dreamsourcelab.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bachp
      carlossless
    ];
  };
})
