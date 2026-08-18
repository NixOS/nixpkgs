{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  popt,
  bluezSupport ? stdenv.hostPlatform.isLinux,
  bluez,
  readlineSupport ? true,
  readline,
  enableConduits ? true,
  bison,
  enableLibpng ? true,
  libpng,
  enableLibusb ? true,
  libusb-compat-0_1,
}:

stdenv.mkDerivation {
  pname = "pilot-link";
  version = "0.13.0-unstable-2026-04-25";

  src = fetchFromGitHub {
    owner = "desrod";
    repo = "pilot-link";
    rev = "fa3c832fb0aabd9465664309168abf278fd38f2a";
    hash = "sha256-EZwE2iO1QZCzv5uVYTpUaHS9tIlBASs5W8i9f3QV4Ks=";
  };

  # Resolve build issues on modern systems.
  # https://github.com/desrod/pilot-link/issues/16
  # https://aur.archlinux.org/packages/pilot-link-git
  patches = [
    ./incompatible-pointer-type.patch
  ]
  ++ lib.optionals enableConduits [ ./format-string-literals.patch ]
  ++ lib.optionals enableLibpng [ ./pilot-link-png14.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals enableConduits [ bison ];

  buildInputs = [
    popt
  ]
  ++ lib.optionals bluezSupport [ bluez ]
  ++ lib.optionals enableLibpng [ libpng ]
  ++ lib.optionals enableLibusb [ libusb-compat-0_1 ]
  ++ lib.optionals readlineSupport [ readline ];

  configureFlags = [
    "--with-libiconv"
  ]
  ++ lib.optionals enableConduits [ "--enable-conduits" ]
  ++ lib.optionals enableLibpng [ "--enable-libpng" ]
  ++ lib.optionals enableLibusb [ "--enable-libusb" ];

  enableParallelBuilding = true;

  meta = {
    description = "Suite of tools for connecting to PalmOS handheld devices";
    homepage = "https://github.com/desrod/pilot-link";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
