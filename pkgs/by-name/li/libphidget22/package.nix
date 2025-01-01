{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "libphidget22";
  version = "0-unstable-2024-04-11";

  src = fetchurl {
    url = "https://cdn.phidgets.com/downloads/phidget22/libraries/linux/libphidget22.tar.gz";
    hash = "sha256-mDoYVs0LhBb3+vzKjzYr9EmcrztmA4cy9xh5ONxHaxI=";
  };

  nativeBuildInputs = [ automake ];

  buildInputs = [ libusb1 ];

  strictDeps = true;

  meta = {
    description = "Phidget Inc sensor boards and electronics Library";
    homepage = "https://www.phidgets.com/docs/OS_-_Linux";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mksafavi ];
    platforms = lib.platforms.linux;
  };
}
