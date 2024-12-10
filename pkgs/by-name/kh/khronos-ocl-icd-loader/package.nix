{
  lib,
  stdenv,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  withTracing ? false,
}:

stdenv.mkDerivation rec {
  pname = "opencl-icd-loader";
  version = "2024.05.08";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${version}";
    hash = "sha256-wFwc1ku3FNEH2k8TJij2sT7JspWorR/XbxXwPZaQcGA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-headers ];

  cmakeFlags = [
    (lib.cmakeBool "OCL_ICD_ENABLE_TRACE" withTracing)
  ];

  meta = with lib; {
    description = "Official Khronos OpenCL ICD Loader";
    mainProgram = "cllayerinfo";
    homepage = "https://github.com/KhronosGroup/OpenCL-ICD-Loader";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.unix;
  };
}
