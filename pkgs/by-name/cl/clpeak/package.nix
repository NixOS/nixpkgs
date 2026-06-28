{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ocl-icd,
  opencl-clhpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clpeak";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "krrishnarraj";
    repo = "clpeak";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-wiS3Liyu20snjVorkf/Kgffz5adEWBInNpxlFjVCQ2E=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    ocl-icd
    opencl-clhpp
  ];

  meta = {
    description = "Tool which profiles OpenCL devices to find their peak capacities";
    homepage = "https://github.com/krrishnarraj/clpeak/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.xokdvium ];
    mainProgram = "clpeak";
  };
})
