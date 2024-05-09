{ lib, stdenv, fetchFromGitHub, autoreconfHook, flac, libao, libogg, popt }:

stdenv.mkDerivation (finalAttrs: {
  pname = "flac123";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "flac123";
    repo = "flac123";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-LtL69t2r9TlIkpQWZLge8ib7NZ5rvLW6JllG2UM16Kw=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ flac libao libogg popt ];

  meta = with lib; {
    homepage = "https://flac-tools.sourceforge.net/";
    description = "A command-line program for playing FLAC audio files";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    mainProgram = "flac123";
  };
})
