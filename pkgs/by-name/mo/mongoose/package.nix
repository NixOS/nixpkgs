{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  blas,
  llvmPackages,
}:

let
  suitesparseVersion = "7.11.0";
in
stdenv.mkDerivation {
  pname = "mongoose";
  version = "3.3.5";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    tag = "v${suitesparseVersion}";
    hash = "sha256-8CnN2P/W15GpK0nCNoRQongOrzcz5E8l9SgKksqLxd0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    blas
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    "-DBLAS_LIBRARIES=${blas}"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  buildPhase = ''
    runHook preBuild

    for f in SuiteSparse_config Mongoose; do
      (cd $f && cmakeConfigurePhase && make -j$NIX_BUILD_CORES)
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for f in SuiteSparse_config Mongoose; do
      (cd $f/build && make install -j$NIX_BUILD_CORES)
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Graph Coarsening and Partitioning Library";
    mainProgram = "suitesparse_mongoose";
    homepage = "https://github.com/DrTimothyAldenDavis/SuiteSparse/tree/dev/Mongoose";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
  };
}
