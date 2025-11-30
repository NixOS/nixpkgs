{
  autoAddDriverRunpath,
  config,
  cudaPackages,
  fetchFromGitHub,
  lib,
}:
let
  inherit (lib.lists) last map optionals;
  inherit (lib.trivial) boolToString;
  inherit (config) cudaSupport;
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    libcublas
    ;
  inherit (cudaPackages.flags) cudaCapabilities dropDots isJetsonBuild;
in
backendStdenv.mkDerivation {
  pname = "gpu-burn";
  version = "0-unstable-2024-04-09";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wilicc";
    repo = "gpu-burn";
    rev = "9aefd7c0cc603bbc8c3c102f5338c6af26f8127c";
    hash = "sha256-Nz0yaoHGfodaYl2HJ7p+1nasqRmxwPJ9aL9oxitXDpM=";
  };

  postPatch = ''
    substituteInPlace gpu_burn-drv.cpp \
      --replace-fail \
        '#define COMPARE_KERNEL "compare.ptx"' \
        '#define COMPARE_KERNEL "${placeholder "out"}/share/compare.ptx"'
    substituteInPlace Makefile \
      --replace-fail \
        '${''''${CUDAPATH}/bin/nvcc''}' \
        '${lib.getExe cuda_nvcc}'
  '';

  nativeBuildInputs = [
    autoAddDriverRunpath
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cccl # <nv/target>
    cuda_cudart # driver_types.h
    cuda_nvcc # crt/host_defines.h
    libcublas # cublas_v2.h
  ];

  makeFlags = [
    # NOTE: CUDAPATH assumes cuda_cudart is a single output containing all of lib, dev, and stubs.
    "CUDAPATH=${cuda_cudart}"
    "COMPUTE=${last (map dropDots cudaCapabilities)}"
    "IS_JETSON=${boolToString isJetsonBuild}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share}
    install -Dm755 gpu_burn $out/bin/
    install -Dm644 compare.ptx $out/share/
    runHook postInstall
  '';

  # NOTE: Certain packages may be missing from cudaPackages on non-Linux platforms. To avoid evaluation failure,
  # we only include the platforms where we know the package is available -- thus the conditionals setting the
  # platforms and badPlatforms fields.
  meta = {
    badPlatforms = optionals (!cudaSupport) lib.platforms.all;
    broken = !cudaSupport;
    description = "Multi-GPU CUDA stress test";
    homepage = "http://wili.cc/blog/gpu-burn.html";
    license = lib.licenses.bsd2;
    mainProgram = "gpu_burn";
    maintainers = with lib.maintainers; [ connorbaker ];
    platforms = optionals cudaSupport lib.platforms.linux;
  };
}
