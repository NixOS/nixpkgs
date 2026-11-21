{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "basis-universal";
  version = "2.50.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    tag = "v${lib.strings.replaceString "." "_" (lib.versions.majorMinor finalAttrs.version)}";
    hash = "sha256-/dqtHr5wELHjB7N/nWRP/UL2sImWUh9nQqzJEzcl0nk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BASISU_EXAMPLES" false)
  ];

  patches = [
    # basis_universal does not provide proper cmake install target, not a basisuConfig.cmake for downstream consumption
    # This patch is from the unmerged https://github.com/BinomialLLC/basis_universal/pull/420 PR
    ./cmake-install-and-exports.patch
  ];

  meta = {
    description = "Basis Universal GPU Texture Codec";
    homepage = "https://github.com/BinomialLLC/basis_universal";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
