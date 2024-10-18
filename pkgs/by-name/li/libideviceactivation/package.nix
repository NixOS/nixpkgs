{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  automake,
  autoreconfHook,
  pkg-config,

  curl,
  libimobiledevice,
  libplist,
  libtool,
  libxml2,
  usbmuxd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libideviceactivation";
  version = "1.1.1-unstable-2024-05-29";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libideviceactivation";
    rev = "ecc10ef8048c6591b936c5ca1b0971157087e6b2";
    hash = "sha256-iD6TJGwKjR6otzN0KL4BX+6DeEX5Z0oJcZlfzHr1lMc=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    automake
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    libimobiledevice
    libplist
    libtool
    libxml2
    usbmuxd
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libideviceactivation";
    description = "Library to manage the activation process of Apple iOS devices";
    license = with licenses; [
      gpl3Only
      lgpl21Only
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      clebs
      frontear
    ];
    mainProgram = "ideviceactivation";
  };
})
