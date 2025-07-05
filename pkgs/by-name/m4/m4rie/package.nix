{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  m4ri,
}:

stdenv.mkDerivation rec {
  version = "20250128";
  pname = "m4rie";

  src = fetchFromGitHub {
    owner = "malb";
    repo = "m4rie";
    rev = version;
    hash = "sha256-tw6ZX8hKfr9wQLF2nuO1dSkkTYZX6pzNWMlWfzLqQNE=";
  };

  doCheck = true;

  buildInputs = [
    m4ri
  ];

  # does not compile correctly with -O2 on LLVM clang; see
  # https://bitbucket.org/malb/m4rie/issues/23/trying-to-compile-on-apple-m1
  makeFlags = [ ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "CFLAGS=-O0" ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://malb.bitbucket.io/m4rie/";
    description = "Library for matrix multiplication, reduction and inversion over GF(2^k) for 2 <= k <= 10";
    longDescription = ''
      M4RIE is a library for fast arithmetic with dense matrices over small finite fields of even characteristic.
      It uses the M4RI library, implementing the same operations over the finite field F2.
    '';
    license = licenses.gpl2Plus;
    teams = [ teams.sage ];
    platforms = platforms.unix;
  };
}
