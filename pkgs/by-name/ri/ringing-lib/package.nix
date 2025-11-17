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
  version = "0-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "ringing-lib";
    repo = "ringing-lib";
    rev = "838d13edb3231d8c122d3222da1b465e2018757f";
    hash = "sha256-MO5FerQMyWDV/cV2hrY/L+JyhMojtaqPQkw8efaVu1I=";
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
