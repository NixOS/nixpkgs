{
  lib,
  stdenv,
  fetchFromGitHub,
  ocl-icd,
  opencl-headers,
}:

stdenv.mkDerivation rec {
  pname = "clinfo";
  version = "3.0.25.02.14";

  src = fetchFromGitHub {
    owner = "Oblomov";
    repo = "clinfo";
    rev = version;
    sha256 = "sha256-UkkrRpmY5vZtTeEqPNYfxAGaJDoTSrNUG9N1Bknozow=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    ocl-icd
    opencl-headers
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = "https://github.com/Oblomov/clinfo";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      athas
      r-burns
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = "https://github.com/Oblomov/clinfo";
    license = licenses.cc0;
    maintainers = with maintainers; [
      athas
      r-burns
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "clinfo";
  };
}
