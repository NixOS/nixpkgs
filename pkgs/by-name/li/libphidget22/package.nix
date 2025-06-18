{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
}:
let
  # This package should be updated together with libphidget22extra
  version = "1.22.20250324";
in
stdenv.mkDerivation {
  pname = "libphidget22";
  inherit version;

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22/libphidget22-${version}.tar.gz";
    hash = "sha256-FR/+b4z73LtGQdT4gypre9SZmZSiWzP/Q+00uia1lhA=";
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
