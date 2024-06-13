{ stdenv, fetchFromGitHub, lib, autoreconfHook, pkg-config, readline, xercesc }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ringing-lib";
  version = "unstable-2023-01-14";

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = finalAttrs.pname;
    rev = "2649ca69f24b531cfc67027898c2db2cc778a394";
    sha256 = "sha256-Lm9lWH2LTKm1NX34BVa0P0k2Qsz9JUqgNPM6roGmNss=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ readline xercesc ];

  doCheck = true;

  meta = with lib; {
    description = "Library of C++ classes and utilities for change ringing";
    homepage = "https://ringing-lib.github.io/";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = with maintainers; [ jshholland ];
    platforms = platforms.linux;
  };
})
