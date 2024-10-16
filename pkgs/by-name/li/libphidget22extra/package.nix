{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
  libphidget22,
}:

stdenv.mkDerivation rec {
  pname = "libphidget22extra";
  version = "1.20.20240909";

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22extra/libphidget22extra-${version}.tar.gz";
    hash = "sha256-/08pzaGeWSAbHezE0BOayWdp+iv+DtrHMVN7CJlZAJc=";
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
