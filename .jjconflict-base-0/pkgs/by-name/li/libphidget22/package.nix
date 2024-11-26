{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
}:
let
  # This package should be updated together with libphidget22extra
  version = "1.21.20241122";
in
stdenv.mkDerivation {
  pname = "libphidget22";
  inherit version;

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22/libphidget22-${version}.tar.gz";
    hash = "sha256-6Sib9CSaPUbAdyHfoSgQ6g4oik7+pjb7g79QftSeVIk=";
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
