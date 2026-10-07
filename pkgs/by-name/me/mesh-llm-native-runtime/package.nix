{
  lib,
  stdenv,
  fetchFromGitHub,
  autoAddDriverRunpath,
  cmake,
  ninja,
  pkg-config,
  gitMinimal,
  jq,
  patchelf,
  python3,
  shaderc,
  spirv-headers,
  vulkan-headers,
  vulkan-loader,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  # NCCL for multi-GPU hosts; nixpkgs' NCCL doesn't support Jetsons before Thor.
  ncclSupport ? cudaSupport && cudaPackages.nccl.meta.available,
  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,
  vulkanSupport ? false,
  metalSupport ? stdenv.hostPlatform.isDarwin,

  # The MeshLLM release; buzz-desktop overrides it with the one it embeds.
  release ? {
    version = "0.78.1";
    hash = "sha256-Au69tcuHXDyGUjRNOS+mGu3nhnaPQQqfoSVJS6jqqF0=";
    # The bNNNNN tag of the llama.cpp commit this release pins.
    llamaCppHash = "sha256-fq8kOKa03uPtoXe5Oi1I3vA5MxJw1J7BFzKXusC4ojc=";
    llamaCppBuild = "11165";
  },
}:

# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
let
  inherit (lib) cmakeBool cmakeFeature optionals;

  # Consistently use backendStdenv with CUDA, as llama-cpp does.
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  # One runtime per backend, as upstream ships them; each includes the CPU backend.
  backend =
    if cudaSupport then
      "cuda"
    else if rocmSupport then
      "rocm"
    else if vulkanSupport then
      "vulkan"
    else if metalSupport then
      "metal"
    else
      "cpu";

  # The backend that MeshLLM's GPU benchmark tool links against.
  gpuBackendLib =
    {
      cuda = "libggml-cuda.so";
      rocm = "libggml-hip.so";
    }
    .${backend} or null;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "mesh-llm-native-runtime";
  inherit (release) version;

  __structuredAttrs = true;
  strictDeps = true;

  # Upstream llama.cpp at the release MeshLLM pins, plus its patch queue.
  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${release.llamaCppBuild}";
    hash = release.llamaCppHash;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    gitMinimal
    jq
    ninja
    patchelf
    pkg-config
    python3
  ]
  ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ]
  # glslc compiles the Vulkan shaders at build time.
  ++ optionals vulkanSupport [ shaderc ];

  buildInputs =
    optionals cudaSupport (
      with cudaPackages;
      [
        cccl
        cuda_cudart
        libcublas
      ]
      ++ optionals ncclSupport [ nccl ]
    )
    ++ optionals rocmSupport (
      with rocmPackages;
      [
        clr
        hipblas
        rocblas
      ]
    )
    ++ optionals vulkanSupport [
      spirv-headers
      vulkan-headers
      vulkan-loader
    ];

  postPatch = ''
    # Apply the patch queue as upstream's scripts/prepare-llama.sh does
    # (core, model_support, generated; `git am --3way`).
    llamaDir=${finalAttrs.passthru.meshLlmSrc}/third_party/llama.cpp
    patchDir=$llamaDir/patches
    queue=("$patchDir"/*.patch)
    for set in model_support generated; do
      if [ -f "$patchDir/$set/series" ]; then
        while IFS= read -r p || [ -n "$p" ]; do queue+=("$patchDir/$set/''${p%$'\r'}"); done < "$patchDir/$set/series"
      fi
    done
    git init -q
    git add -A
    # No automatic gc: it would run in the background while `rm -rf .git` runs.
    gitArgs=(-c user.name=nixbld -c user.email=nixbld@localhost -c core.hooksPath=/dev/null -c gc.auto=0)
    git "''${gitArgs[@]}" commit -q --no-gpg-sign -m base
    git "''${gitArgs[@]}" am -q --3way --no-gpg-sign "''${queue[@]}"
    rm -rf .git

    # llama.cpp reports the commit it was built from; the tarball doesn't carry it.
    appendToVar cmakeFlags "-DLLAMA_BUILD_COMMIT=$(head -c 7 $llamaDir/upstream.txt)"
  '';

  cmakeFlags = [
    (cmakeBool "GGML_NATIVE" false) # -march=native would make builds non-deterministic
    (cmakeBool "BUILD_SHARED_LIBS" true)
    # Only the libraries mesh-llm loads, including the multimodal one.
    (cmakeBool "LLAMA_BUILD_TOOLS" false)
    (cmakeBool "LLAMA_BUILD_SERVER" false)
    (cmakeBool "LLAMA_BUILD_APP" false)
    (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (cmakeBool "LLAMA_BUILD_TESTS" false)
    (cmakeBool "LLAMA_BUILD_MTMD" true)
    (cmakeBool "MTMD_VIDEO" false)
    (cmakeBool "LLAMA_CURL" false)
    (cmakeBool "LLAMA_OPENSSL" false)
    (cmakeFeature "LLAMA_BUILD_NUMBER" finalAttrs.passthru.llamaCppBuild)
    (cmakeBool "GGML_CUDA" cudaSupport)
    (cmakeBool "GGML_HIP" rocmSupport)
    (cmakeBool "GGML_METAL" metalSupport)
    (cmakeBool "GGML_VULKAN" vulkanSupport)
    # All CPU variants as loadable backends; ggml picks one at runtime, from
    # here rather than next to the executable (mesh-llm's or buzz-desktop's).
    (cmakeBool "GGML_CPU_ALL_VARIANTS" true)
    (cmakeBool "GGML_BACKEND_DL" true)
    (cmakeFeature "GGML_BACKEND_DIR" "${placeholder "out"}/lib/ggml-backends")
  ]
  ++ optionals cudaSupport [
    (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    # As upstream's build-llama.sh: CUDA graphs can abort under concurrent requests.
    (cmakeBool "GGML_CUDA_GRAPHS" false)
    (cmakeBool "GGML_CUDA_NCCL" ncclSupport)
  ]
  ++ optionals rocmSupport [
    (cmakeFeature "CMAKE_HIP_COMPILER" "${rocmPackages.clr.hipClangPath}/clang++")
    (cmakeFeature "CMAKE_HIP_ARCHITECTURES" (lib.concatStringsSep ";" rocmGpuTargets))
  ]
  ++ optionals metalSupport [
    (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1")
    (cmakeBool "GGML_METAL_EMBED_LIBRARY" true)
  ];

  # Package with upstream's script, so the manifest stays upstream's format. It runs
  # last, after the postFixupHooks that patch runpaths, because mesh-llm checksums
  # every bundled file. It skips skippy-package-builder, an offline publishing tool
  # mesh-llm doesn't call. https://github.com/Mesh-LLM/mesh-llm/pull/2392 turns
  # both patches below into flags.
  preFixup = ''
    packageNativeRuntime() {
      cp -r ${finalAttrs.passthru.meshLlmSrc} mesh-llm && chmod -R u+w mesh-llm
      # Keep the store paths after $ORIGIN (upstream sets $ORIGIN only); the GPU
      # benchmark tool gets the runpath of the backend it measures.
      substituteInPlace mesh-llm/scripts/package-native-runtime.sh \
        --replace-fail $'\nbuild_model_package_tool\n' $'\n' \
        --replace-fail 'patchelf --set-rpath "\$ORIGIN"' 'patchelf --set-rpath "\$ORIGIN:$(patchelf --print-rpath "$library")"' \
        --replace-fail 'patchelf --set-rpath "\$ORIGIN/../lib"' 'patchelf --set-rpath "\$ORIGIN/../lib:$GPU_BACKEND_RUNPATH"'
      ${lib.optionalString (gpuBackendLib != null) ''
        export GPU_BACKEND_RUNPATH=$(patchelf --print-rpath $out/lib/ggml-backends/${gpuBackendLib})
      ''}
      ${lib.optionalString cudaSupport ''
        # Upstream's CUDA bundles carry libcudart and its license for that tool.
        export CUDA_LIBRARY_PATH=${cudaPackages.cuda_cudart}/lib
        export MESH_LLM_CUDA_LICENSE_FILE=${cudaPackages.cuda_cudart}/LICENSE
        # Upstream builds the tool PTX-only, which drivers older than the toolkit
        # can't load. https://github.com/Mesh-LLM/mesh-llm/pull/2303
        export NVCC_APPEND_FLAGS="${cudaPackages.flags.gencodeString}"
      ''}
      ${lib.optionalString rocmSupport ''
        # The GPU benchmark tool, built with hipcc for the same GPUs as the backend.
        export HIPCC=${rocmPackages.clr}/bin/hipcc
        export LLAMA_STAGE_AMDGPU_TARGETS="${lib.concatStringsSep ";" rocmGpuTargets}"
      ''}
      mkdir core && cp -P $out/lib/lib*${effectiveStdenv.hostPlatform.extensions.sharedLibrary}* core/
      LLAMA_STAGE_BUILD_DIR=$PWD/core \
        bash mesh-llm/scripts/package-native-runtime.sh --backend ${backend} --out $out/share/mesh-llm/runtimes
      rm $out/share/mesh-llm/runtimes/*.tar.gz*

      # A distinct id and the top rank: mesh-llm uses this bundle instead of
      # downloading upstream's.
      for m in $out/share/mesh-llm/runtimes/*/manifest.json; do
        jq '.runtime.id += "-nixpkgs" | .runtime.rank = 1000' "$m" > "$m.tmp"
        mv "$m.tmp" "$m"
      done
    }
    postFixupHooks+=(packageNativeRuntime)
  '';

  passthru = {
    inherit backend;
    # Environment for the programs that load this bundle (mesh-llm, buzz-desktop).
    hostEnvironment =
      lib.optionalAttrs effectiveStdenv.hostPlatform.isGnu {
        # mesh-llm compares against the system's glibc, but the bundle runs on this one.
        MESH_LLM_GLIBC_VERSION = lib.versions.majorMinor effectiveStdenv.cc.libc.version;
      }
      // lib.optionalAttrs cudaSupport {
        # mesh-llm wants a detected CUDA toolkit; the bundle finds CUDA via its runpath.
        MESH_LLM_CUDA_TOOLKIT_MAJOR = cudaPackages.cudaMajorVersion;
      };
    meshLlmSrc = fetchFromGitHub {
      owner = "Mesh-LLM";
      repo = "mesh-llm";
      tag = "v${finalAttrs.version}";
      inherit (release) hash;
    };
    # llama.cpp release number of src (its bNNNNN tag), reported by the library.
    inherit (release) llamaCppBuild;

  };

  meta = {
    description = "Patched llama.cpp libraries that MeshLLM loads for inference (${backend} backend)";
    longDescription = ''
      The inference engine of mesh-llm and buzz-desktop, which bundle it;
      install those instead. The backend is chosen with `cudaSupport`,
      `rocmSupport`, `vulkanSupport` (also as mesh-llm-native-runtime-vulkan)
      and `metalSupport` (the default on macOS), otherwise it is CPU only.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm";
    changelog = "https://github.com/Mesh-LLM/mesh-llm/releases/tag/v${finalAttrs.version}";
    # llama.cpp is MIT; MeshLLM's patches are MIT or Apache-2.0. CUDA bundles also
    # carry a copy of NVIDIA's libcudart.
    license =
      with lib.licenses;
      [
        mit
        asl20
      ]
      ++ optionals cudaSupport cudaPackages.cuda_cudart.meta.license;
    sourceProvenance =
      with lib.sourceTypes;
      [ fromSource ] ++ optionals cudaSupport [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kleinbem ];
    # What upstream's scripts/package-native-runtime.sh can package.
    platforms = lib.intersectLists (lib.platforms.linux ++ lib.platforms.darwin) (
      lib.platforms.x86_64 ++ lib.platforms.aarch64
    );
    badPlatforms = optionals (cudaSupport || rocmSupport) lib.platforms.darwin;
    broken = metalSupport && !effectiveStdenv.hostPlatform.isDarwin;
  };
})
