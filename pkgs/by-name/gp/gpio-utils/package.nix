{
  lib,
  stdenv,
  linux,
}:

stdenv.mkDerivation {
  pname = "gpio-utils";
  version = linux.version;

  inherit (linux) src;
  makeFlags = linux.commonMakeFlags ++ [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preConfigure = ''
    cd tools/gpio
  '';

  separateDebugInfo = true;
  installFlags = [
    "install"
    "DESTDIR=$(out)"
    "bindir=/bin"
  ];

  meta = {
    description = "Linux tools to inspect the gpiochip interface";
    maintainers = with lib.maintainers; [ kwohlfahrt ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}
