{
  lib,
  stdenv,
  fetchurl,
  automake,
  libusb1,
}:
let
  # This package should be updated together with libphidget22extra
<<<<<<< HEAD
  version = "1.23.20250925";
=======
  version = "1.22.20250714";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenv.mkDerivation {
  pname = "libphidget22";
  inherit version;

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22/libphidget22-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-/2OgjiuoK3+gJ95tSk809OfMABUtKPN9bb4pVH447Ik=";
=======
    hash = "sha256-QsdNyShJkKtRHNtezO9jF2ZUilrTaqZBMTp+UcWNkhA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
