{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  flint,
  gmp,
}:

stdenv.mkDerivation {
  pname = "pplite";
  version = "0.12";

  src = fetchurl {
    url = "https://github.com/ezaffanella/PPLite/raw/main/releases/pplite-0.12.tar.gz";
    hash = "sha256-9qulVEIZRPHV5GnVmp65nMrGrUwRGkR8i8ORbLdHb1E=";
  };

  buildInputs = [
    flint
    gmp
  ];

  patches = [
    # https://github.com/ezaffanella/PPLite/pull/1
    (fetchpatch {
      name = "flint-3_2.patch";
      url = "https://github.com/ezaffanella/PPLite/commit/96fd1e50131f70bb78efdd60985525e970c9df06.patch";
      hash = "sha256-8FNyL8h/rBm2Hegib2l08vqEmFDU0PhMCV8Ui2G4xHQ=";
    })
  ];

  meta = {
    homepage = "https://github.com/ezaffanella/PPLite";
    description = "Convex polyhedra library for Abstract Interpretation";
    mainProgram = "pplite_lcdd";
    license = lib.licenses.gpl3Only;
  };
}
