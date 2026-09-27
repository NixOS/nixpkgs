{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  cacert,
  python3,
  rocmPackages,
  cudaPackages,
  unstableGitUpdater,
  backend ? "cpu",

  # CPU microarchitecture for `-march=` (e.g. "x86-64-v3", "native").
  # Defaults to empty (baseline ISA, reproducible) unless overridden; upstream default of `-march=native` is host-specific.
  cpuTarget ? null,

  # CUDA GPU arch, e.g. "sm_89". Defaults to the host platform's cudaPackages support
  cudaArch ? null,

  # ROCm GPU target, e.g. "gfx1151". Defaults to the build host's detected GPU target
  rocmArch ? null,
}:

assert lib.elem backend [
  "cpu"
  "rocm"
  "cuda"
];

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      huggingface-hub
      hf-xet
    ]
  );

  # ROCm libraries the gfx kernels and link flags (-lhipblas -lhipblaslt) need.
  rocmInputs = [
    rocmPackages.clr # provides hipcc + HIP runtime
    rocmPackages.hipblas
    rocmPackages.hipblas-common # hipblas.h includes hipblas-common/hipblas-common.h
    rocmPackages.hipblaslt
    rocmPackages.rocblas
    rocmPackages.rocwmma # gfx1151 backend uses rocWMMA headers
    rocmPackages.hipcub
    rocmPackages.rocprim
    rocmPackages.rocthrust
    rocmPackages.rocm-runtime
  ];

  rocmLibDirs = map (p: "${lib.getLib p}/lib") rocmInputs;
  rocmLinkFlags = lib.concatStringsSep " " (map (d: "-L${d} -Wl,-rpath,${d}") rocmLibDirs);
  rocmIncludeFlags = lib.concatStringsSep " " (map (p: "-I${lib.getDev p}/include") rocmInputs);

  cudaLibDirs = [
    "${lib.getLib cudaPackages.cuda_cudart}/lib"
    "${lib.getLib cudaPackages.libcublas}/lib"
  ];
  cudaLinkFlags = lib.concatStringsSep " " (
    map (d: "-L${d} -Xlinker -rpath -Xlinker ${d}") cudaLibDirs
  );

  resolvedCudaArch =
    if cudaArch != null then cudaArch else builtins.head (cudaPackages.flags.realArches or [ "sm_89" ]);

  # ROCm arch default: the project's own upstream target (strix-halo ==
  # gfx1151). Deliberately NOT `head (clr.gpuTargets)` — bare
  # `rocmPackages.clr.localGpuTargets` is null unless an arch-scoped
  # rocmPackages is used, so the fallback would silently pick the first
  # (oldest) supported target (gfx900), which rocwmma rejects ("static
  # assertion failed: Unsupported architecture"). Set `rocmArch` to build
  # for another GPU.
  resolvedRocmArch = if rocmArch != null then rocmArch else "gfx1151";

  # -march for host code; empty (baseline) unless cpuTarget is set (upstream embeds NATIVE_CPU_FLAG everywhere).
  marchFlag = lib.optionalString (cpuTarget != null) "-march=${cpuTarget}";

  buildTarget =
    {
      cpu = "cpu";
      rocm = "strix-halo";
      cuda = "cuda";
    }
    .${backend};

  backendMakeFlags =
    {
      cpu = [ ];
      rocm = [ "ROCM_ARCH=${resolvedRocmArch}" ];
      cuda = [
        "NVCC=${lib.getExe' cudaPackages.cuda_nvcc "nvcc"}"
        "CUDA_HOME=${cudaPackages.cuda_nvcc}"
        "CUDA_ARCH=${resolvedCudaArch}"
      ];
    }
    .${backend};

  backendMakeFlagsArray =
    {
      cpu = [ ];
      rocm = [
        "ROCM_CFLAGS=-O3 -ffast-math -g -fno-finite-math-only -pthread -D__HIP_PLATFORM_AMD__ -Wno-unused-command-line-argument --offload-arch=${resolvedRocmArch} ${rocmIncludeFlags}"
        "ROCM_LDLIBS=-lm -pthread ${rocmLinkFlags} -lhipblas -lhipblaslt -lrocblas"
      ];
      cuda = [
        # Replace upstream's hardcoded paths with the nixpkgs cudart/cublas store paths.
        "NVCCFLAGS=-O3 -g -lineinfo --use_fast_math $(NVCC_ARCH_FLAGS)${
          lib.optionalString (marchFlag != "") " -Xcompiler ${marchFlag}"
        } -Xcompiler -pthread"
        "CUDA_LDLIBS=-lm -Xcompiler -pthread ${cudaLinkFlags} -lcudart -lcublas"
      ];
    }
    .${backend};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ds4" + lib.optionalString (backend != "cpu") "-${backend}";
  version = "0-unstable-2026-09-16";

  src = fetchFromGitHub {
    owner = "antirez";
    repo = "ds4";
    rev = "8db1d1d155cb0400a86a86b9c62d0defb3a6148b";
    hash = "sha256-d0TRJH5/cNlDrgJy2i9eEUuSAlnka0BvxDXlXIwMwrE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (backend == "rocm") [ rocmPackages.clr ]
  ++ lib.optionals (backend == "cuda") [ cudaPackages.cuda_nvcc ];

  buildInputs =
    lib.optionals (backend == "rocm") rocmInputs
    ++ lib.optionals (backend == "cuda") [
      cudaPackages.cuda_cudart
      cudaPackages.libcublas
    ];

  makeFlags = [ "NATIVE_CPU_FLAG=${marchFlag}" ] ++ backendMakeFlags ++ backendMakeFlagsArray;
  buildFlags = [ buildTarget ];

  # CPU-runnable tests only; the GPU variants are validated on real hardware.
  doCheck = backend == "cpu";
  checkPhase = ''
    runHook preCheck
    local flagsArray=()
    concatTo flagsArray makeFlags
    make "''${flagsArray[@]}" tests/test_layer_pack tests/test_gpu_args q4k-dot-test mxfp4-dot-test
    ./tests/test_layer_pack
    ./tests/test_gpu_args
    ./ds4-eval --self-test-extractors
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t "$out/bin" ds4 ds4-server ds4-bench ds4-eval ds4-agent

    # Wrap upstream's GGUF downloader as `ds4-download-model`, patching its
    # project-root detection to use $DS4_HOME (default: cwd) instead of the
    # read-only store path that `dirname $0` resolves to.
    install -Dm755 download_model.sh "$out/bin/ds4-download-model"
    substituteInPlace "$out/bin/ds4-download-model" \
      --replace-fail 'ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)' 'ROOT=''${DS4_HOME:-$PWD}' \
      --replace-warn './download_model.sh' 'ds4-download-model'
    runHook postInstall
  '';

  # `ds4-download-model` shells out to curl (and optionally the `hf` CLI for the
  # huge PRO files); make curl available and point it at a CA bundle if the
  # environment doesn't already set one.
  postFixup = ''
    wrapProgram "$out/bin/ds4-download-model" \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          pythonEnv
        ]
      } \
      --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  # Only the CPU variant is guaranteed to run without a GPU/device present, so
  # restrict the smoke check to it. GPU variants are validated on real hardware.
  doInstallCheck = backend == "cpu";
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/ds4" --help >/dev/null
    runHook postInstallCheck
  '';

  # Keep the package current automatically: upstream has no releases, so the
  # r-ryantm update bot bumps the pin to the latest `main` commit on every run.
  passthru.updateScript = unstableGitUpdater {
    branch = "main";
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "DwarfStar (Local Inference Engine for GLM, DeepSeek and others)";
    homepage = "https://github.com/antirez/ds4";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = lib.platforms.linux;
    mainProgram = "ds4";
    maintainers = with lib.maintainers; [ asosnovsky ];
  };
})
