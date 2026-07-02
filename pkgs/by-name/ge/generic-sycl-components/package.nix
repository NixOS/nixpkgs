{
  fetchFromGitHub,
  intelLlvmStdenv,
  cmake,
  ninja,
  lib,
  # The GPU to tune for. Does not affect dependencies pulled in.
  # Must be one of:
  #  DEFAULT, INTEL_GPU, NVIDIA_GPU, AMD_GPU
  gpuTuningTarget ? "DEFAULT",
}:
assert lib.assertOneOf "gpuTuningTarget" gpuTuningTarget [
  "DEFAULT"
  "INTEL_GPU"
  "NVIDIA_GPU"
  "AMD_GPU"
];
intelLlvmStdenv.mkDerivation (finalAttrs: {
  pname = "generic-sycl-components";
  version = "unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "generic-sycl-components";
    # There are currently no tagged releases, see this issue:
    # https://github.com/uxlfoundation/generic-sycl-components/issues/16
    rev = "99241128f64b700392e4cfdd047caada024bf7dd";
    hash = "sha256-JIyWclCJVqrllP5zYFv8T9wurCLixAetLVzQYt27pGY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  sourceRoot = "${finalAttrs.src.name}/onemath/sycl/blas";

  cmakeFlags = [
    (lib.cmakeFeature "TUNING_TARGET" gpuTuningTarget)
  ];

  meta = {
    description = "SYCL-based BLAS kernels used as the generic BLAS backend for oneMath";
    homepage = "https://github.com/uxlfoundation/generic-sycl-components";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
    platforms = lib.platforms.linux;
  };
})
