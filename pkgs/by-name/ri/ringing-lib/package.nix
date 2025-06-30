{
  stdenv,
  fetchFromGitHub,
  lib,
  autoreconfHook,
  pkg-config,
  readline,
  xercesc,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ringing-lib";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "ringing-lib";
    repo = "ringing-lib";
    rev = "4f791c559743499589d66dc44266cd681f6901de";
    hash = "sha256-+P2x2ywk7Ev7GacfUONusVHjlE6bIVBeJasjlcw5kTU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    readline
    xercesc
  ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  meta = {
    description = "Library of C++ classes and utilities for change ringing";
    homepage = "https://ringing-lib.github.io/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ jshholland ];
    platforms = lib.platforms.linux;
  };
})
