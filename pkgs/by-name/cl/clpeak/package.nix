{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ocl-icd,
  opencl-clhpp,
}:

stdenv.mkDerivation rec {
  pname = "clpeak";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "krrishnarraj";
    repo = "clpeak";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-unQLZ5EExL9lU2XuYLJjASeFzDA74+TnU0CQTWyNYiQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    ocl-icd
    opencl-clhpp
  ];

  meta = with lib; {
    description = "Tool which profiles OpenCL devices to find their peak capacities";
    homepage = "https://github.com/krrishnarraj/clpeak/";
    license = licenses.unlicense;
    maintainers = [ ];
    mainProgram = "clpeak";
  };
}
