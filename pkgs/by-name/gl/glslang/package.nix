{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  jq,
  python3,
  spirv-headers,
  spirv-tools,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glslang";
  version = "16.1.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = finalAttrs.version;
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
    bison
    jq
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

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ralith ];
  };
})
