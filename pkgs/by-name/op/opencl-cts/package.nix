{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  opencl-headers,
  spirv-headers,
  spirv-tools,
  ocl-icd,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-cts";
  version = "2025-08-21-00";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CTS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/VVT7Q45OvVivbZvULInXf78//Tb3EeV8zqbcDR2Pf4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    opencl-headers
    spirv-headers
    spirv-tools
    ocl-icd
  ];

  # Build errors when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    (lib.cmakeFeature "CL_INCLUDE_DIR" "${lib.getInclude opencl-headers}/include")
    # Intentionally no suffix, CMakeLists adds for SPIRV and not for CL ¯\_(ツ)_/¯
    (lib.cmakeFeature "SPIRV_INCLUDE_DIR" "${lib.getInclude spirv-headers}")
    (lib.cmakeFeature "CL_LIB_DIR" "${lib.getLib ocl-icd}/lib")
    (lib.cmakeFeature "SPIRV_TOOLS_DIR" "${lib.getBin spirv-tools}/bin")
    (lib.cmakeFeature "OPENCL_LIBRARIES" "OpenCL")
  ];

  meta = {
    description = "OpenCL Conformance Test Suite";
    homepage = "https://github.com/KhronosGroup/OpenCL-CTS";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.rocm ];
  };
})
