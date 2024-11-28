{ lib
, stdenv
, fetchFromGitHub
, cmake
, autoconf
, automake
, libtool
}:

stdenv.mkDerivation {
  pname = "aacgain";
  version = "2.0.0-unstable-2022-07-12";

  src = fetchFromGitHub {
    owner = "dgilman";
    repo = "aacgain";
    rev = "9f9ae95a20197d1072994dbd89672bba2904bdb5";
    hash = "sha256-WqL9rKY4lQD7wQSZizoM3sHNzLIG0E9xZtjw8y7fgmE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing";

  meta = with lib; {
    description = "ReplayGain for AAC files";
    homepage = "https://github.com/dgilman/aacgain";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.robbinch ];
    mainProgram = "aacgain";
  };
}
