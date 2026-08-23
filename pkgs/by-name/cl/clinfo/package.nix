{
  lib,
  stdenv,
  fetchFromGitHub,
  ocl-icd,
  opencl-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clinfo";
  version = "3.0.25.02.14";

  src = fetchFromGitHub {
    owner = "Oblomov";
    repo = "clinfo";
    rev = finalAttrs.version;
    sha256 = "sha256-UkkrRpmY5vZtTeEqPNYfxAGaJDoTSrNUG9N1Bknozow=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    ocl-icd
    opencl-headers
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = "https://github.com/Oblomov/clinfo";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      athas
      r-burns
    ];
    platforms = lib.platforms.unix;
    mainProgram = "clinfo";
  };
})
