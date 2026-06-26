{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  imgui,
  SDL2,
  libxext,
  imnodes,
  withExamples ? false,
}:

stdenv.mkDerivation {
  pname = "imnodes";
  version = "unstable-2025-06-25";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Nelarius";
    repo = "imnodes";
    rev = "b2ec254ce576ac3d42dfb7aef61deadbff8e7211";
    hash = "sha256-Hdde198chSm3Ii0grEB4imqp7vVu6mYxa1VPZovvb7A=";
  };
  patches = [
    # CMake install rules
    (fetchpatch {
      url = "https://github.com/Nelarius/imnodes/commit/ff20336fcd82ce07c39fabd76d5bc9fa0a08b3bc.patch";
      hash = "sha256-JHOUjwMofDwt2kg6SLPFZmuQC4bOfjGa3qHFr5MdPIE=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    imgui
  ]
  ++ lib.optionals withExamples [
    SDL2
    libxext
  ];

  cmakeFlags = [ (lib.cmakeBool "IMNODES_EXAMPLES" withExamples) ];

  passthru.tests.examples = imnodes.override { withExamples = true; };

  meta = {
    description = "Small, dependency-free node editor for dear imgui";
    homepage = "https://github.com/Nelarius/imnodes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "imnodes";
    platforms = lib.platforms.all;
  };
}
