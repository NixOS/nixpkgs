{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation {
  pname = "fasttext";
  version = "0.9.2-unstable-2023-11-28";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = "6c2204ba66776b700095ff73e3e599a908ffd9c3";
    hash = "sha256-lSIah4T+QqZwCRpeI3mxJ7PZT6pSHBO26rcEFfK8DSk=";
  };

  patches = [
    # Fix build with CMake 4
    # Upstream repo is archived, so we take a patch from Debian
    (fetchurl {
      url = "https://salsa.debian.org/science-team/fasttext/-/raw/b2a0e52d302b32b6786b1a8fb9c0b21ca23e2be9/debian/patches/fix-ftbfs-cmake4.patch";
      hash = "sha256-I5w+/4SNyp2FtHGYBWU2Fi76vmJpG4nbgsb0akVddAs=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library for text classification and representation learning";
    mainProgram = "fasttext";
    homepage = "https://fasttext.cc/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
