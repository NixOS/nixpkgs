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
  versionCheckHook,
  gitUpdater,

  # Required for compiling to SPIR-V or GLSL
  withGlslang ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shader-slang";
  version = "2025.18.2";

  src = fetchFromGitHub {
    owner = "shader-slang";
    repo = "slang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9upf/4Ix4ReV4OlkPMzLMJo4DlAXydQLSEp+GM+tN2g=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Header location has moved in glslang 15+
    substituteInPlace source/slang-glslang/slang-glslang.cpp \
      --replace-fail '"SPIRV/GlslangToSpv.h"' '"glslang/SPIRV/GlslangToSpv.h"'
  '';

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
    (lib.cmakeFeature "CMAKE_CONFIGURATION_TYPES" "RelWithDebInfo")
    # Handled by separateDebugInfo so we don't need special installation handling
    (lib.cmakeBool "SLANG_ENABLE_SPLIT_DEBUG_INFO" false)
    (lib.cmakeFeature "SLANG_VERSION_FULL" "v${finalAttrs.version}-nixpkgs")
    (lib.cmakeBool "SLANG_USE_SYSTEM_MINIZ" true)
    (lib.cmakeBool "SLANG_USE_SYSTEM_LZ4" true)
    (lib.cmakeBool "SLANG_USE_SYSTEM_UNORDERED_DENSE" true)
    (lib.cmakeFeature "SLANG_SLANG_LLVM_FLAVOR" "DISABLE")
    # slang-rhi tries to download headers and precompiled binaries for these backends
    (lib.cmakeBool "SLANG_RHI_ENABLE_OPTIX" false)
    (lib.cmakeBool "SLANG_RHI_ENABLE_VULKAN" false)
    (lib.cmakeBool "SLANG_RHI_ENABLE_METAL" false)
    (lib.cmakeBool "SLANG_RHI_ENABLE_WGPU" false)
  ]
  ++ lib.optionals withGlslang [
    (lib.cmakeBool "SLANG_USE_SYSTEM_SPIRV_TOOLS" true)
    (lib.cmakeBool "SLANG_USE_SYSTEM_GLSLANG" true)
  ]
  ++ lib.optionals (!withGlslang) [
    (lib.cmakeBool "SLANG_ENABLE_SLANG_GLSLANG" false)
  ];

  postInstall = ''
    mkdir -p $dev/lib
    mv {$out,$dev}/lib/cmake
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
    maintainers = with lib.maintainers; [
      niklaskorz
      samestep
    ];
    mainProgram = "slangc";
    platforms = lib.platforms.all;
  };
})
