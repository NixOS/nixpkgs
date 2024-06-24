{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  curl,
  fftw,
  gtk3,
  gtkdatabox,
  jansson,
  libad9361,
  libiio,
  libxml2,
  matio,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iio-oscilloscope";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}-master";
    hash = "sha256-wCeOLAkrytrBaXzUbNu8z2Ayz44M+b+mbyaRoWHpZYU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    fftw
    gtk3
    gtkdatabox
    jansson
    libad9361
    libiio
    libxml2
    matio
    pcre2
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";
  cmakeFlags = [ "-DCMAKE_POLKIT_PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Analog Devices' oscilloscope software for Industrial IO (IIO) devices";
    homepage = "https://wiki.analog.com/resources/tools-software/linux-software/iio_oscilloscope";
    license = licenses.gpl2;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
  };
})
