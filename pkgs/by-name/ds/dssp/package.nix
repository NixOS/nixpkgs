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
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UE97bdSx41K962TqXLlKsp8oDnBBX7uXqsfIzhWjsTI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    eigen
    libcifpp
    libmcfp
    zlib
  ];

  meta = {
    description = "Calculate the most likely secondary structure assignment given the 3D structure of a protein";
    mainProgram = "mkdssp";
    homepage = "https://github.com/PDB-REDO/dssp";
    changelog = "https://github.com/PDB-REDO/dssp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.unix;
  };
})
