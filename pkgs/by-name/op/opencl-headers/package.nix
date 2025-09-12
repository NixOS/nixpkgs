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
  version = "2025.07.22";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XcDzBt4EAsip+5/lbZwPBO7/nDGAognUkJO/2Jg4OeY=";
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
