{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
  libphidget22,
}:
let

  # This package should be updated together with libphidget22
  version = "1.22.20250324";
in
stdenv.mkDerivation {
  pname = "libphidget22extra";
  inherit version;

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22extra/libphidget22extra-${version}.tar.gz";
    hash = "sha256-8FTd/hyqzZKWN68FAxrV1N0pPglNAbZ/aRH4V6hEgBM=";
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
