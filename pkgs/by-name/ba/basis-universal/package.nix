{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "basis-universal";
  version = "2.50.0";

  src = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    tag = "v2_50";
    hash = "sha256-/dqtHr5wELHjB7N/nWRP/UL2sImWUh9nQqzJEzcl0nk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBASISU_EXAMPLES=OFF"
  ];

  patches = [
    # basis_universal does not provide proper cmake install target, not a basisuConfig.cmake for downstream consumption
    # This patch is from the unmerged https://github.com/BinomialLLC/basis_universal/pull/420 PR
    (fetchpatch {
      url = "https://github.com/BinomialLLC/basis_universal/commit/8c4c65b6ed079a3a012a895b10d044fd9452dea5.patch";
      hash = "sha256-ksISAzxyEXnTs6/wVjLYX3C/rDctgxdNmGCNqPD8FQM="; # Replace with the patch hash (or use lib.fakeHash to let Nix find it)
    })
  ];

  meta = with lib; {
    description = "Basis Universal GPU Texture Codec";
    homepage = "https://github.com/BinomialLLC/basis_universal";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
