{
  lib,
  stdenv,
  fetchFromGitHub,
  srcOnly,
  cmake,
  psimd,
}:

stdenv.mkDerivation {
  pname = "fp16-luxonis";
  version = "0-unstable-2021-07-27";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "fp16";
    rev = "c911175d2717e562976e606c6e5f799bf40cf94e";
    hash = "sha256-4U5WmqqljHYoKdKqtFRBX++vGCv/3weuqPFr4WG7GNM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeFeature "PSIMD_SOURCE_DIR" (builtins.toString (srcOnly psimd)))
    (lib.cmakeBool "FP16_BUILD_TESTS" false)
    (lib.cmakeBool "FP16_BUILD_BENCHMARKS" false)
  ];

  meta = {
    description = "Header-only library for conversion to/from half-precision floating point formats";
    homepage = "https://github.com/luxonis/fp16";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 tmayoff ];
  };
}
