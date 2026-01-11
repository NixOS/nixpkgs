{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  spirv-headers,
  spirv-tools,
  config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glslang";
  version = "16.1.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    tag = finalAttrs.version;
    hash = "sha256-cEREniYgSd62mnvKaQkgs69ETL5pLl5Gyv3hKOtSv3w=";
  };

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

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_EXTERNAL" false)
    (lib.cmakeBool "ALLOW_EXTERNAL_SPIRV_TOOLS" true)
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
