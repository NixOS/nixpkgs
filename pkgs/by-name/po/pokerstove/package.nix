{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation {
  pname = "pokerstove";
  version = "1.1-unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "andrewprock";
    repo = "pokerstove";
    rev = "ae377e23cfd0cf2a5e2cdc11891a93307a30a65d";
    hash = "sha256-7hqvd+cl6rvzvdb33+Too7XbFqMZc7FMlkKnvX/9y/o=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  cmakeFlags = [
    "-DBUILD_PYTHON=OFF"
    "-DBUILD_WHEEL=OFF"
  ];

  meta = {
    homepage = "https://github.com/andrewprock/pokerstove";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stephsi ];
    mainProgram = "ps-eval";
    description = "Highly hand optimized C++ poker hand evaluation library";
  };
}
