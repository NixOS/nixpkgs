{
  lib,
  stdenv,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  withTracing ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-icd-loader";
  version = "2025.07.22";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jwviNwX7C7b9lqIS4oZ4YLEFBfBdmQfXHxW3FPPYxYs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-headers ];

  cmakeFlags = [
    (lib.cmakeBool "OCL_ICD_ENABLE_TRACE" withTracing)
  ];

  meta = {
    description = "Official Khronos OpenCL ICD Loader";
    mainProgram = "cllayerinfo";
    homepage = "https://github.com/KhronosGroup/OpenCL-ICD-Loader";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
