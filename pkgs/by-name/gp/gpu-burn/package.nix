{
  lib,
  autoAddDriverRunpath,
  config,
  cudaPackages,
  fetchFromGitHub,
  nix-update-script,
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.trivial) boolToString;
  inherit (config) cudaSupport;
  inherit (cudaPackages)
    backendStdenv
    cccl
    cuda_cudart
    cuda_nvcc
    libcublas
    ;
  inherit (cudaPackages.flags) gencodeString isJetsonBuild;
in
backendStdenv.mkDerivation {
  pname = "gpu-burn";
  version = "0-unstable-2026-05-27";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wilicc";
    repo = "gpu-burn";
    rev = "dfc30426a45613a36b5da53ef901a1e29d3db374";
    hash = "sha256-/gDD6t3gGtPEZVageQyVRIb87gTa0yeygE45zmOVli4=";
  };

  postPatch = ''
    substituteInPlace gpu_burn-drv.cpp \
      --replace-fail \
        '#define COMPARE_KERNEL "compare.fatbin"' \
        '#define COMPARE_KERNEL "${placeholder "out"}/share/compare.fatbin"'
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
    cccl # <nv/target>
    cuda_cudart # driver_types.h
    cuda_nvcc # crt/host_defines.h
    libcublas # cublas_v2.h
  ];

  makeFlags = [
    # NOTE: CUDAPATH assumes cuda_cudart is a single output containing all of lib, dev, and stubs.
    "CUDAPATH=${cuda_cudart}"
    "IS_JETSON=${boolToString isJetsonBuild}"
    # Empty COMPUTE suppresses the Makefile's default -arch=compute_$(COMPUTE);
    # gencodeString below is the single source of truth for architectures.
    "COMPUTE="
  ];

  env.NVCCFLAGS = gencodeString;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share}
    install -Dm755 gpu_burn $out/bin/
    install -Dm644 compare.fatbin $out/share/
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
