{
  lib,
  cmake,
  fetchFromGitHub,
  stdenv,
  suitesparse-graphblas,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suitesparse-lagraph";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "GraphBLAS";
    repo = "LAGraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nvV/fMqBBtp9S4gVqVWc958Ocb827OCu2uXxSiVTJUc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    suitesparse-graphblas
  ];

  # The GraphBLAS JIT writes its cache to $HOME.
  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  doCheck = true;
  # Tests are flaky in parallel; upstream runs them serially.
  enableParallelChecking = false;

  meta = {
    description = "Library of graph algorithms based on GraphBLAS";
    homepage = "https://github.com/GraphBLAS/LAGraph";
    changelog = "https://github.com/GraphBLAS/LAGraph/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.unix;
  };
})
