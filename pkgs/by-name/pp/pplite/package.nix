{
  stdenv,
  lib,
  fetchurl,
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

  meta = {
    homepage = "https://github.com/ezaffanella/PPLite";
    description = "Convex polyhedra library for Abstract Interpretation";
    mainProgram = "pplite_lcdd";
    license = lib.licenses.gpl3Only;
  };
}
