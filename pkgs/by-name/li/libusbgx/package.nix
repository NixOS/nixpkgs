{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libconfig,
  autoreconfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libusbgx";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "libusbgx";
    tag = "libusbgx-v${finalAttrs.version}";
    hash = "sha256-cG9hSv9TEs9+nfVtMrh88Gsg3P45aH+dr0d98hzqo0I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libconfig ];

  passthru.updateScript = nix-update-script { };

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
