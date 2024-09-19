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
  version = "1.1.1-unstable-2024-05-29";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libideviceactivation";
    rev = "ecc10ef8048c6591b936c5ca1b0971157087e6b2";
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

  meta = with lib; {
    homepage = "https://libimobiledevice.org";
    description = "Library to manage the activation process of Apple iOS devices";
    license = with licenses; [
      lgpl21
      gpl3
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [
      clebs
      frontear
    ];
    mainProgram = "ideviceactivation";
  };
})
