{
  lib,
  stdenv,
  linux,
}:

stdenv.mkDerivation {
  pname = "gpio-utils";
  version = linux.version;

<<<<<<< HEAD
  inherit (linux) src;
  makeFlags = linux.commonMakeFlags ++ [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];
=======
  inherit (linux) src makeFlags;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  preConfigure = ''
    cd tools/gpio
  '';

  separateDebugInfo = true;
  installFlags = [
    "install"
    "DESTDIR=$(out)"
    "bindir=/bin"
  ];

<<<<<<< HEAD
  meta = {
    description = "Linux tools to inspect the gpiochip interface";
    maintainers = with lib.maintainers; [ kwohlfahrt ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Linux tools to inspect the gpiochip interface";
    maintainers = with maintainers; [ kwohlfahrt ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
