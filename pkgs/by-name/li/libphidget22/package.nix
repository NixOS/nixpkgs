{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
}:
let
  version = "1.20.20240909";
in
stdenv.mkDerivation {
  pname = "libphidget22";
  inherit version;

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22/libphidget22-${version}.tar.gz";
    hash = "sha256-20Y7cukEzq/Rf2v91SYTC1yCtS4p5aaG4aK8x6/6ebk=";
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
