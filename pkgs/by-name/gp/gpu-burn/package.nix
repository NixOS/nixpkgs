{
  lib,
  autoAddDriverRunpath,
  config,
  cudaPackages,
  fetchFromGitHub,
  nix-update-script,
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
  version = "0-unstable-2025-11-04";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wilicc";
    repo = "gpu-burn";
    rev = "671f4be92477ce01cd9b536bc534a006dbee058f";
    hash = "sha256-zaGzwpdvF9dw3RypBO+g6FhjOFN8/F9+yI1+lLxLjgs=";
  };

  postPatch = ''
    substituteInPlace gpu_burn-drv.cpp \
      --replace-fail \
        '#define COMPARE_KERNEL "compare.ptx"' \
        '#define COMPARE_KERNEL "${placeholder "out"}/share/compare.ptx"'
    substituteInPlace Makefile \
      --replace-fail \
        '${"\${CUDAPATH}/bin/nvcc"}' \
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

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
    maintainers = with lib.maintainers; [
      GaetanLepage
      connorbaker
    ];
    platforms = optionals cudaSupport lib.platforms.linux;
  };
}
