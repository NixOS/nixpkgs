{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  miniz,
  lz4,
  libxml2,
  libX11,
  glslang,
  unordered_dense,
  llvmPackages,
  versionCheckHook,
  gitUpdater,

  # Required for compiling to SPIR-V or GLSL
  withGlslang ? true,
  # Can be used for compiling shaders to CPU targets, see:
  # https://github.com/shader-slang/slang/blob/master/docs/cpu-target.md
  # If `withLLVM` is disabled, Slang will fall back to the C++ compiler found
  # in the environment, if one exists.
  withLLVM ? false,
  # Dynamically link against libllvm and libclang++ (upstream defaults to static)
  withSharedLLVM ? withLLVM,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shader-slang";
  version = "2025.17.2";

  src = fetchFromGitHub {
    owner = "shader-slang";
    repo = "slang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bviodruPqvw2L9E6qSO0ihg9L/qK33A03bpr1bI+xR8=";
    fetchSubmodules = true;
  };

  patches =
    lib.optionals withSharedLLVM [
      # Upstream statically links libllvm and libclang++, resulting in a ~5x increase in binary size.
      ./1-shared-llvm.patch
    ]
    ++ lib.optionals withGlslang [
      # Upstream depends on glslang 13 and there are minor breaking changes in glslang 15, the version
      # we ship in nixpkgs.
      ./2-glslang-15.patch
    ];

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    miniz
    lz4
    libxml2
    unordered_dense
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
  ]
  ++ lib.optionals withLLVM [
    llvmPackages.llvm
    llvmPackages.libclang
  ]
  ++ lib.optionals withGlslang [
    # SPIRV-tools is included in glslang.
    glslang
  ];

  separateDebugInfo = true;

  # Required for spaces in cmakeFlags, see https://github.com/NixOS/nixpkgs/issues/114044
  __structuredAttrs = true;

  preConfigure =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # required to handle LTO objects
      export AR="${stdenv.cc.targetPrefix}gcc-ar"
      export NM="${stdenv.cc.targetPrefix}gcc-nm"
      export RANLIB="${stdenv.cc.targetPrefix}gcc-ranlib"
    ''
    + ''
      # cmake setup hook only sets CMAKE_AR and CMAKE_RANLIB, but not these
      prependToVar cmakeFlags "-DCMAKE_CXX_COMPILER_AR=$(command -v $AR)"
      prependToVar cmakeFlags "-DCMAKE_CXX_COMPILER_RANLIB=$(command -v $RANLIB)"
    '';

  cmakeFlags = [
    "-GNinja Multi-Config"
    # The cmake setup hook only specifies `-DCMAKE_BUILD_TYPE=Release`,
    # which does nothing for "Ninja Multi-Config".
    "-DCMAKE_CONFIGURATION_TYPES=RelWithDebInfo"
    # Handled by separateDebugInfo so we don't need special installation handling
    "-DSLANG_ENABLE_SPLIT_DEBUG_INFO=OFF"
    "-DSLANG_VERSION_FULL=v${finalAttrs.version}-nixpkgs"
    "-DSLANG_USE_SYSTEM_MINIZ=ON"
    "-DSLANG_USE_SYSTEM_LZ4=ON"
    (lib.cmakeBool "SLANG_USE_SYSTEM_UNORDERED_DENSE" true)
    "-DSLANG_SLANG_LLVM_FLAVOR=${if withLLVM then "USE_SYSTEM_LLVM" else "DISABLE"}"
    # slang-rhi tries to download headers and precompiled binaries for these backends
    "-DSLANG_RHI_ENABLE_OPTIX=OFF"
    "-DSLANG_RHI_ENABLE_VULKAN=OFF"
    "-DSLANG_RHI_ENABLE_METAL=OFF"
    "-DSLANG_RHI_ENABLE_WGPU=OFF"
  ]
  ++ lib.optionals withGlslang [
    "-DSLANG_USE_SYSTEM_SPIRV_TOOLS=ON"
    "-DSLANG_USE_SYSTEM_GLSLANG=ON"
  ]
  ++ lib.optional (!withGlslang) "-DSLANG_ENABLE_SLANG_GLSLANG=OFF";

  postInstall = ''
    mv "$out/cmake" "$dev/cmake"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/slangc";
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "*-draft";
  };

  meta = {
    description = "Shading language that makes it easier to build and maintain large shader codebases in a modular and extensible fashion";
    homepage = "https://github.com/shader-slang/slang";
    changelog = "https://github.com/shader-slang/slang/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "slangc";
    platforms = lib.platforms.all;
    # Slang only supports LLVM 14:
    # https://github.com/shader-slang/slang/blob/v2025.15/docs/building.md#llvm-support
    broken = withLLVM;
  };
})
