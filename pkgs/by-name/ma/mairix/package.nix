{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  bzip2,
  bison,
  flex,
}:

stdenv.mkDerivation {
  pname = "mairix";
  version = "0.24-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "vandry";
    repo = "mairix";
    rev = "f6c7a5aa141d2b201e8a299ab889ff1ed23992ea";
    hash = "sha256-7SgBbQPuz07eoZJ9km6yYEjkyf2p+BPW1ec0X2X8pKE=";
  };

  buildInputs = [
    zlib
    bzip2
    bison
    flex
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.rc0.org.uk/mairix";
    license = lib.licenses.gpl2Plus;
    description = "Program for indexing and searching email messages stored in maildir, MH or mbox";
    mainProgram = "mairix";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
