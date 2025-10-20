{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libconfig,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libusbgx";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "libusbgx";
    tag = "libusbgx-v${finalAttrs.version}";
    sha256 = "sha256-cG9hSv9TEs9+nfVtMrh88Gsg3P45aH+dr0d98hzqo0I=";
  };
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libconfig ];
  meta = {
    description = "C library encapsulating the kernel USB gadget-configfs userspace API functionality";
    license = with lib.licenses; [
      lgpl21Plus # library
      gpl2Plus # examples
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
