{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libconfig,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "libusbgx";
  version = "0-unstable-2021-10-31";
  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "libusbgx";
    rev = "060784424609d5a4e3bce8355f788c93f09802a5";
    hash = "sha256-Z6Jmtk3sFNyvMhwMcOvHS3BgUvzJwUZRyPIEtR+CWJw=";
  };
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libconfig ];
  meta = {
    description = "C library encapsulating the kernel USB gadget-configfs userspace API functionality";
    homepage = "https://github.com/linux-usb-gadgets/libusbgx";
    license = with lib.licenses; [
      lgpl21Plus # library
      gpl2Plus # examples
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
