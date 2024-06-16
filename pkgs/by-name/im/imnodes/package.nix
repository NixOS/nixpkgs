{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  imgui,
  SDL2,
  xorg,
  imnodes,
  withExamples ? false,
}:

stdenv.mkDerivation rec {
  pname = "imnodes";
  version = "unstable-2024-03-12";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Nelarius";
    repo = "imnodes";
    rev = "8563e1655bd9bb1f249e6552cc6274d506ee788b";
    hash = "sha256-E7NNCxYq9dyVvutWbpl2a+D2Ap2ErvdYHBDqpX0kb0c=";
  };
  patches = [
    # CMake install rules
    (fetchpatch {
      url = "https://github.com/Nelarius/imnodes/commit/ff20336fcd82ce07c39fabd76d5bc9fa0a08b3bc.patch";
      hash = "sha256-JHOUjwMofDwt2kg6SLPFZmuQC4bOfjGa3qHFr5MdPIE=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ imgui ]
    ++ lib.optionals withExamples [
      SDL2
      xorg.libXext
    ];

  cmakeFlags = [ (lib.cmakeBool "IMNODES_EXAMPLES" withExamples) ];

  passthru.tests.examples = imnodes.override { withExamples = true; };

  meta = {
    description = "A small, dependency-free node editor for dear imgui";
    homepage = "https://github.com/Nelarius/imnodes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "imnodes";
    platforms = lib.platforms.all;
  };
}
