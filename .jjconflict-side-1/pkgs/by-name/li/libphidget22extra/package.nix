{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
  libphidget22,
}:

stdenv.mkDerivation {
  pname = "libphidget22extra";
  version = "0-unstable-2024-04-11";

  src = fetchurl {
    url = "https://cdn.phidgets.com/downloads/phidget22/libraries/linux/libphidget22extra.tar.gz";
    hash = "sha256-UD6Crr1dl7c3NOAVNi3xrXJI3OYPLZBJX1MXVvbyEUE=";
  };

  nativeBuildInputs = [ automake ];

  buildInputs = [
    libphidget22
    libusb1
  ];

  strictDeps = true;

  meta = {
    description = "Phidget Inc sensor boards and electronics extras library";
    homepage = "https://www.phidgets.com/docs/OS_-_Linux";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mksafavi ];
    platforms = lib.platforms.linux;
  };
}
