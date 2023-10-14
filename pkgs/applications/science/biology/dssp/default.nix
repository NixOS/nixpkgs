{ lib
, stdenv
, cmake
, eigen
, fetchFromGitHub
, libcifpp
, libmcfp
, zlib
}:
let
  libcifpp' = libcifpp.overrideAttrs (oldAttrs: {
    # dssp 4.4.3 requires specific version "5.2.0" of libcifpp
    version = "5.2.0";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo rev;
      hash = "sha256-Sj10j6HxUoUvQ66cd2B8CO7CVBRd7w9CTovxkwPDOvs=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dssp";
  version = "4.4.3";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-zPmRR7sxVNErwabLqA5CNMO4K1qHdmC9FBPjcx91KuM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
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
