{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  hashcat,
  ocl-icd,
  tesseract,
  testers,
  opencl-clhpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-headers";
  version = "2024.10.24";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KDlruE0IG8d+lAChxYyc6dg5XOvqCMrMyO69sdAzejA=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit
      ocl-icd
      tesseract
      hashcat
      opencl-clhpp
      ;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "OpenCL-Headers" ];
    };
  };

  meta = {
    description = "Khronos OpenCL headers version ${finalAttrs.version}";
    homepage = "https://www.khronos.org/registry/cl/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = [ lib.maintainers.xokdvium ];
  };
})
