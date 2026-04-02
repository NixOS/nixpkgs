{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  gtest,
  python3,
  spirv-headers,
  spirv-tools,
  config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glslang";
  version = "16.2.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    tag = finalAttrs.version;
    hash = "sha256-2uWnZZNGdZorHaiLzMb/rpM6bL9oBClKqiFkUH3krJQ=";
  };

  patches = [
    # Allow building against our already-built gtest, without eating a rebuild
    # https://github.com/KhronosGroup/glslang/pull/4140
    ./external-gtest.patch
  ];

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [
    spirv-tools
    spirv-headers
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_EXTERNAL" false)
    (lib.cmakeBool "ALLOW_EXTERNAL_SPIRV_TOOLS" true)
    (lib.cmakeBool "ALLOW_EXTERNAL_GTEST" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  disabledTests =
    # CompileToAstTest.FromFile/array_frag looks for result of UB, expected output is LE
    # https://github.com/KhronosGroup/glslang/issues/2797
    # GlslNonSemanticShaderDebugInfoSpirv13Test.FromFile/spv_debuginfo_coopmatKHR_comp has endianness-issues
    # https://github.com/KhronosGroup/glslang/issues/4145
    lib.optionals (!stdenv.hostPlatform.isLittleEndian) [
      "glslang-gtests"
    ];

  postInstall = ''
    # add a symlink for backwards compatibility
    ln -s $bin/bin/glslang $bin/bin/glslangValidator
  '';

  passthru = lib.optionalAttrs config.allowAliases {
    # Added 2026-01-06, https://github.com/NixOS/nixpkgs/pull/477412
    spirv-tools = throw "'glslang' no longer pins to specific 'spirv-tools'";

    # Added 2026-01-06, https://github.com/NixOS/nixpkgs/pull/477412
    spirv-headers = throw "'glslang' no longer pins to specific 'spirv-headers'";
  };

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ralith ];
  };
})
