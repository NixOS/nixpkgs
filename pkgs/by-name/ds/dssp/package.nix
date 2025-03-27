{
  lib,
  stdenv,
  cmake,
  eigen,
  fetchFromGitHub,
  libcifpp,
  libmcfp,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dssp";
  version = "4.4.11";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7L9pdKWDa/g/r+cuou2b0pqS559qwuwHBBhDDhvM7VE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
    libcifpp
    libmcfp
    zlib
  ];

  meta = with lib; {
    description = "Calculate the most likely secondary structure assignment given the 3D structure of a protein";
    mainProgram = "mkdssp";
    homepage = "https://github.com/PDB-REDO/dssp";
    changelog = "https://github.com/PDB-REDO/dssp/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
