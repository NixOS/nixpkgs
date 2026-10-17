{
  lib,
  stdenv,
  mkDerivation,
  llvmPackages,
  writableTmpDirAsHomeHook,
}:

mkDerivation {
  pname = "graphblas";
  version = "10.2.0";
  moduleName = "GraphBLAS";

  nativeBuildInputs = [
    # Needs to create directories as part of the build for the JIT
    writableTmpDirAsHomeHook
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "GRAPHBLAS_USE_JIT" true)
  ];

  meta = {
    description = "Graph algorithms in the language of linear algebra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
