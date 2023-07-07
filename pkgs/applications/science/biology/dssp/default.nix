{ lib
, stdenv
, cmake
, fetchFromGitHub
, libcifpp
, libmcfp
, zlib
}:
let
  libcifpp' = libcifpp.overrideAttrs (oldAttrs: {
    # dssp 4.3.1 requires specific version "5.1.0" of libcifpp
    version = "5.1.0";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo rev;
      hash = "sha256-PUsi4T6huSqwaa6RnBP1Vj+0a1ePrvrHD0641Lkkc5s=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dssp";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-TE2fus3KaGd9jo7cOWmJSooHjxTbcxEldR1Mui2SGP0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libcifpp'
    libmcfp
    zlib
  ];

  meta = with lib; {
    description = "Calculate the most likely secondary structure assignment given the 3D structure of a protein";
    homepage = "https://github.com/PDB-REDO/dssp";
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/${finalAttrs.src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
