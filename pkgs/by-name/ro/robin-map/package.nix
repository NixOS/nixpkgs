{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = "robin-map";
    tag = "v${version}";
    hash = "sha256-dspOWp/8oNR0p5XRnqO7WtPcCx54/y8m1cDho4UBYyc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    homepage = "https://github.com/Tessil/robin-map";
    changelog = "https://github.com/Tessil/robin-map/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
