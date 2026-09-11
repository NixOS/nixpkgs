{
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  automake,
  autoreconfHook,
  libtool,
  libplist,
  libimobiledevice,
  libxml2,
  curl,
  usbmuxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libideviceactivation";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libideviceactivation";
    tag = finalAttrs.version;
    hash = "sha256-owcQpCN4+A785oy9pCboJIyfpgZ6X+8PRzqGtWpYl2w=";
  };

  nativeBuildInputs = [
    pkg-config
    automake
    autoreconfHook
  ];

  buildInputs = [
    libtool
    libplist
    libimobiledevice
    libxml2
    curl
    usbmuxd
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Library to manage the activation process of Apple iOS devices";
    homepage = "https://libimobiledevice.org";
    license = with lib.licenses; [
      lgpl21
      gpl3
    ];
    mainProgram = "ideviceactivation";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ clebs ];
  };
})
