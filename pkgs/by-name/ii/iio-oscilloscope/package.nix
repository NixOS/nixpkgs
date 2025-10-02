{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  libiio,
  glib,
  gtk3,
  gtkdatabox,
  matio,
  fftw,
  libxml2,
  curl,
  jansson,
  enable9361 ? true,
  libad9361,
# enable9166 ? true,
# libad9166,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iio-oscilloscope";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "iio-oscilloscope";
    rev = "v${finalAttrs.version}-master";
    hash = "sha256-wCeOLAkrytrBaXzUbNu8z2Ayz44M+b+mbyaRoWHpZYU=";
  };

  patches = [
    # make sure the sizeof argument to calloc is the second argument.
    (fetchpatch {
      url = "https://github.com/analogdevicesinc/iio-oscilloscope/commit/565cade20566d50adec7be191a6dd7b21217f878.patch";
      hash = "sha256-JeRve3xtWi+EcZR+qZlek+YwAbPB56OYxkFVd8MmIb0=";
    })
  ];

  postPatch = ''
    # error: 'idx' may be used uninitialized
    substituteInPlace plugins/lidar.c --replace-fail "int i, j, idx;" "int i, j, idx = 0;"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libiio
    glib
    gtk3
    gtkdatabox
    matio
    fftw
    libxml2
    curl
    jansson
  ]
  ++ lib.optional enable9361 libad9361;

  cmakeFlags = [
    "-DCMAKE_POLKIT_PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "GTK+ based oscilloscope application for interfacing with various IIO devices";
    homepage = "https://wiki.analog.com/resources/tools-software/linux-software/iio_oscilloscope";
    mainProgram = "osc";
    license = lib.licenses.gpl2Only;
    changelog = "https://github.com/analogdevicesinc/iio-oscilloscope/releases/tag/v${finalAttrs.version}-master";
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
})
