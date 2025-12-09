{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = "robin-map";
    tag = "v${version}";
    hash = "sha256-Hkgxiq2i0TuqMK/bI5OMOn3LkmSE40NimDjK1FBZpsA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    homepage = "https://github.com/Tessil/robin-map";
    changelog = "https://github.com/Tessil/robin-map/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
