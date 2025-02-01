{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  darwin,
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
  version = "0.12.3-unstable-2022-09-26";

  src = fetchFromGitHub {
    owner = "desrod";
    repo = "pilot-link";
    rev = "14338868111ce592c7ca7918a1f8a32ceecb7caf";
    hash = "sha256-3b5T/QnRZawnjTgwvQKUbJTE/NiJ93eU2+qbRFuI13I";
  };

  # Resolve build issues on modern systems.
  # https://github.com/desrod/pilot-link/issues/16
  # https://aur.archlinux.org/packages/pilot-link-git
  patches =
    [ ./configure-checks.patch ]
    ++ lib.optionals enableConduits [ ./format-string-literals.patch ]
    ++ lib.optionals enableLibpng [ ./pilot-link-png14.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ] ++ lib.optionals enableConduits [ bison ];

  buildInputs =
    [ popt ]
    ++ lib.optionals bluezSupport [ bluez ]
    ++ lib.optionals enableLibpng [ libpng ]
    ++ lib.optionals enableLibusb [ libusb-compat-0_1 ]
    ++ lib.optionals readlineSupport [ readline ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ IOKit ]);

  configureFlags =
    [ "--with-libiconv" ]
    ++ lib.optionals enableConduits [ "--enable-conduits" ]
    ++ lib.optionals enableLibpng [ "--enable-libpng" ]
    ++ lib.optionals enableLibusb [ "--enable-libusb" ];

  meta = {
    description = "Suite of tools for connecting to PalmOS handheld devices";
    homepage = "https://github.com/desrod/pilot-link";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
