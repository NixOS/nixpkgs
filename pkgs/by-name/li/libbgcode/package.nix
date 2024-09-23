{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, heatshrink
, zlib
, boost
, catch2
}:
stdenv.mkDerivation {
  pname = "libbgcode";
  version = "2023-11-16";

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "libbgcode";
    rev = "bc390aab4427589a6402b4c7f65cf4d0a8f987ec";
    hash = "sha256-TZShYeDAh+fNdmTr1Xqctji9f0vEGpNZv1ba/IY5EoY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    heatshrink
    zlib
    boost
    catch2
  ];

  meta = with lib; {
    homepage = "https://github.com/prusa3d/libbgcode";
    description = "Prusa Block & Binary G-code reader / writer / converter";
    mainProgram = "bgcode";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ lach ];
    platforms = platforms.unix;
  };
}
