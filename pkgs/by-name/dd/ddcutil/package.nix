{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  glib,
  jansson,
  udev,
  libgudev,
  libusb1,
  libdrm,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "2.2.1";

  src = fetchurl {
    url = "https://www.ddcutil.com/tarballs/ddcutil-${version}.tar.gz";
    hash = "sha256-cch2DDg91fohgXg5uGuYUKxtVY4TPi1v6ojfrwREiuY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    jansson
    libdrm
    libgudev
    libusb1
    udev
    xorg.libXext
    xorg.libXrandr
  ];

  enableParallelBuilding = true;
  doInstallCheck = true;

  meta = {
    homepage = "http://www.ddcutil.com/";
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    changelog = "https://github.com/rockowitz/ddcutil/blob/v${version}/CHANGELOG.md";
    mainProgram = "ddcutil";
  };
}
