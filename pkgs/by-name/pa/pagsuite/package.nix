{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gmp,
  scalp,
}:

stdenv.mkDerivation {
  pname = "pagsuite";
  version = "1.80-unstable-2025-05-03";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "kumm";
    repo = "pagsuite";
    rev = "1cc657765658cb2eb622d4a9c656ab9854150e7d";
    hash = "sha256-jyp3h5n6SkyTpLzqMezvu2nri6rDkX3ACcCO9r4/bBA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gmp
    scalp
  ];

  # make[2]: ***  No rule to make target 'lib/libpag.dylib', needed by 'bin/osr'.  Stop.
  enableParallelBuilding = false;

  meta = with lib; {
    description = "Optimization tools for the (P)MCM problem";
    homepage = "https://gitlab.com/kumm/pagsuite";
    maintainers = with maintainers; [ wegank ];
    license = licenses.unfree;
  };
}
