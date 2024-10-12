{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, libiio
, glib
, gtk3
, gtkdatabox
, matio
, fftw
, libxml2
, curl
, jansson
, enable9361 ? true, libad9361
# , enable9166 ? true, libad9166
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

  postPatch = ''
    # error: 'idx' may be used uninitialized
    substituteInPlace plugins/lidar.c --replace "int i, j, idx;" "int i, j, idx = 0;"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
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
  ] ++ lib.optional enable9361 libad9361;

  cmakeFlags = [
    "-DCMAKE_POLKIT_PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "GTK+ based oscilloscope application for interfacing with various IIO devices";
    homepage = "https://wiki.analog.com/resources/tools-software/linux-software/iio_oscilloscope";
    mainProgram = "osc";
    license = licenses.gpl2Only;
    changelog = "https://github.com/analogdevicesinc/iio-oscilloscope/releases/tag/v${finalAttrs.version}-master";
    maintainers = with maintainers; [ chuangzhu ];
  };
})
