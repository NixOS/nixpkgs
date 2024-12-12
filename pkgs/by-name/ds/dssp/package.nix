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
  version = "4.4.10";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-YNYpHjp9kEszXvLF3RrNg6gYd4GPvfRVtdkUwJ89qOc=";
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
    changelog = "https://github.com/PDB-REDO/dssp/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
