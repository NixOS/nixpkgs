{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  desktopToDarwinBundle,
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
  version = "0.18";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "iio-oscilloscope";
    rev = "v${finalAttrs.version}-main";
    hash = "sha256-lAP8rI1YnBMmwWBDxfQOV5W8NYscQbb7lh/ZhG893p0=";
  };

  postPatch = ''
    # error: 'idx' may be used uninitialized
    substituteInPlace plugins/lidar.c --replace-fail "int i, j, idx;" "int i, j, idx = 0;"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace oscmain.c --replace-fail '#include "osc.h"${"\n"}#include "backtrace.h"' '#include "backtrace.h"${"\n"}#include "osc.h"'
    substituteInPlace CMakeLists.txt \
      --replace-fail '-D_GNU_SOURCE' '-D_DARWIN_C_SOURCE' \
      --replace-fail '${"\${CMAKE_SYSTEM_NAME} MATCHES \"Linux\""}' 'TRUE'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
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

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=unused-variable"
  ];

  preInstall = ''
    sed -e 's/Exec=.*/Exec=osc/' \
        -e 's/Icon=.*/Icon=osc/' \
        -i adi-osc.desktop
  '';

  postInstall = ''
    ln -s $out/share/osc/icons/osc.svg $out/share/icons/hicolor/scalable/apps/
  '';

  meta = {
    description = "GTK+ based oscilloscope application for interfacing with various IIO devices";
    homepage = "https://wiki.analog.com/resources/tools-software/linux-software/iio_oscilloscope";
    mainProgram = "osc";
    license = lib.licenses.gpl2Only;
    changelog = "https://github.com/analogdevicesinc/iio-oscilloscope/releases/tag/v${finalAttrs.version}-master";
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.unix;
  };
})
