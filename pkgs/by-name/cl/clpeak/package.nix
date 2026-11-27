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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "krrishnarraj";
    repo = "clpeak";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-+mv4a8sxtmn4j7tv62tYbIn9wwfKHcbLC/jOHgB3a0Q=";
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
