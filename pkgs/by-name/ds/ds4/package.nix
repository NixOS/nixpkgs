{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
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

  # ROCm GPU target, e.g. "gfx1151". Defaults to gfx1151 (Strix Halo).
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
      rocm = [
        "ROCM_ARCH=${resolvedRocmArch}"
        # Keep the upstream Makefile flags and add the ROCm store paths. hipcc
        # drives an unwrapped clang, so it needs explicit include paths and rpaths.
        "ROCM_CFLAGS=-O3 -ffast-math -g -fno-finite-math-only -pthread -D__HIP_PLATFORM_AMD__ -Wno-unused-command-line-argument --offload-arch=$(ROCM_ARCH) ${
          lib.concatMapStringsSep " " (p: "-I${lib.getDev p}/include") rocmInputs
        }"
        "ROCM_LDLIBS=-lm -pthread ${rocmLinkFlags} -lhipblas -lhipblaslt -lrocblas"
      ];
      cuda = [
        "NVCC=${lib.getExe' cudaPackages.cuda_nvcc "nvcc"}"
        "CUDA_HOME=${cudaPackages.cuda_nvcc}"
        "CUDA_ARCH=${resolvedCudaArch}"
      ];
    }
    .${backend};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ds4" + lib.optionalString (backend != "cpu") "-${backend}";
  version = "0-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "antirez";
    repo = "ds4";
    rev = "b3f50180ec2c7324892be1f50bc83555ccb8d5e7";
    hash = "sha256-XccxnYqo33w1mNZNAMFx/rdPhO57lxQ/oKPGSyxzh0E=";
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

  postPatch = lib.optionalString (backend == "cuda") ''
    # The linker wrapper finds cudart and cublas through buildInputs.
    # nvcc needs -Xcompiler for NATIVE_CPU_FLAG only when a CPU target is set.
    substituteInPlace Makefile \
      --replace-fail ' -L$(CUDA_HOME)/targets/sbsa-linux/lib -L$(CUDA_HOME)/lib64' "" \
      --replace-fail '-Xcompiler $(NATIVE_CPU_FLAG) ' '$(if $(strip $(NATIVE_CPU_FLAG)),-Xcompiler $(NATIVE_CPU_FLAG) )'
  '';

  makeFlags = [ "NATIVE_CPU_FLAG=${marchFlag}" ] ++ backendMakeFlags;
  buildFlags = [ buildTarget ];

  doCheck = backend == "cpu";
  # Upstream's full test target links GPU tests with nvcc on Linux.
  checkTarget = "tests/test_layer_pack tests/test_gpu_args q4k-dot-test mxfp4-dot-test";
  postCheck = ''
    ./tests/test_layer_pack
    ./tests/test_gpu_args
    ./ds4-eval --self-test-extractors
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t "$out/bin" ds4 ds4-server ds4-bench ds4-eval ds4-agent
    install -Dm644 -t "$out/libexec/ds4" gguf-tools/merge_deepseek41_shards.py

    # Upstream downloads beside the installed script in the read-only store.
    # Use $DS4_HOME, falling back to the working directory.
    install -Dm755 download_model.sh "$out/bin/ds4-download-model"
    substituteInPlace "$out/bin/ds4-download-model" \
      --replace-fail 'ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)' 'ROOT=''${DS4_HOME:-$PWD}' \
      --replace-fail '$ROOT/gguf-tools/merge_deepseek41_shards.py' "$out/libexec/ds4/merge_deepseek41_shards.py" \
      --replace-warn './download_model.sh' 'ds4-download-model'
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/ds4-download-model" \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          pythonEnv
        ]
      }
  '';

  # Only the CPU variant can run without a GPU
  doInstallCheck = backend == "cpu";
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/ds4" --help >/dev/null
    runHook postInstallCheck
  '';

  # Upstream does not make releases.
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
