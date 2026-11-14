{
  lib,
  stdenv,
  fetchgit,
  cmake,
  hwloc,
  rdma-core,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:
let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "psrdada";
  version = "1.2.3";

  src = fetchgit {
    url = "https://git.code.sf.net/p/psrdada/code";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-yK1Ma+pHsyPZ02m+VcYvZw56OKI879YLLYhjgfkJYCo=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    hwloc
    rdma-core
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ];

  # They hard-code arch in their CMakeLists for some reason
  cmakeFlags = lib.optionals cudaSupport [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  strictDeps = true;

  __structuredAttrs = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Distributed data acquisition library for pulsar astronomy";
    homepage = "https://psrdada.sourceforge.net/";
    changelog = "https://sourceforge.net/p/psrdada/code/ci/${finalAttrs.version}/tree/";
    license = with lib.licenses; [
      afl21
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.linux;
  };
})
