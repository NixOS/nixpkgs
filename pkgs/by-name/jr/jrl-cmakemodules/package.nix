{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,

  catch2_3,
  matio,
  python3Packages,
  simde,
  suitesparse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jrl-cmakemodules";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S9MRMV+xv70tIMFRpj7SQjHiBvMHZvDmG5eeuyzO5zQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "JRL_CMAKEMODULES_GENERATE_API_DOC" true)
    (lib.cmakeBool "JRL_CMAKEMODULES_BUILD_TESTS" finalAttrs.doCheck)
  ];

  doCheck = true;

  checkInputs = [
    catch2_3
    matio
    python3Packages.boost
    python3Packages.nanobind
    python3Packages.numpy
    python3Packages.pytest
    simde
    suitesparse
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    changelog = "https://github.com/jrl-umi3218/jrl-cmakemodules/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
})
