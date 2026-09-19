{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "mongoose";
  moduleName = "Mongoose";
  version = "3.3.6";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Graph Coarsening and Partitioning Library";
    mainProgram = "suitesparse_mongoose";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      qbisi
      wegank
    ];
  };
}
