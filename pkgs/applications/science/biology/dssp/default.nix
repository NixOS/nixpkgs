{ lib
, stdenv
, cmake
, eigen
, fetchFromGitHub
, fetchpatch
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
    patches = [
      (fetchpatch {
        # https://github.com/PDB-REDO/libcifpp/issues/51
        name = "fix-build-on-darwin.patch";
        url = "https://github.com/PDB-REDO/libcifpp/commit/641f06a7e7c0dc54af242b373820f2398f59e7ac.patch";
        hash = "sha256-eWNfp9nA/+2J6xjZR6Tj+5OM3L5MxdfRi0nBzyaqvS0=";
      })
    ];
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dssp";
  version = "4.4.5";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-X0aMWqoMhmQVRHWKVm2S6JAOYiBuBBMzMoivMdpNx0M=";
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
