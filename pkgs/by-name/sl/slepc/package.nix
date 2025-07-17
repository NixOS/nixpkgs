{
  lib,
  stdenv,
  fetchFromGitLab,
  python3,
  python3Packages,
  arpack-mpi,
  petsc,
  mpi,
  mpiCheckPhaseHook,
  pythonSupport ? false,
  withExamples ? false,
  withArpack ? stdenv.hostPlatform.isLinux,
}:
assert petsc.mpiSupport;
assert pythonSupport -> petsc.pythonSupport;
stdenv.mkDerivation (finalAttrs: {
  pname = "slepc";
  version = "3.23.2";

  src = fetchFromGitLab {
    owner = "slepc";
    repo = "slepc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nRY8ARc31Q2Qi8Tf7921vBf5nPpI4evSjmpTYUTUigQ=";
  };

  postPatch = ''
    # Fix slepc4py install prefix
    substituteInPlace config/packages/slepc4py.py \
      --replace-fail "slepc.prefixdir,'lib'" \
      "slepc.prefixdir,'${python3.sitePackages}'"

    patchShebangs lib/slepc/bin
  '';

  # Usually this project is being built as part of a `petsc` build or as part of
  # other projects, e.g when `petsc` is `./configure`d with
  # `--download-slepc=1`. This instructs the slepc to be built as a standalone
  # project.
  preConfigure = ''
    export SLEPC_DIR=$PWD
  '';

  nativeBuildInputs =
    [
      python3
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.setuptools
      python3Packages.cython
    ];

  configureFlags =
    lib.optionals withArpack [
      "--with-arpack=1"
    ]
    ++ lib.optionals pythonSupport [
      "--with-slepc4py=1"
    ];

  buildInputs =
    [
      mpi
    ]
    ++ lib.optionals withArpack [
      arpack-mpi
    ];

  propagatedBuildInputs = [
    petsc
  ];

  enableParallelBuilding = true;

  installTargets = [ (if withExamples then "install" else "install-lib") ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs =
    [
      mpiCheckPhaseHook
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.pythonImportsCheckHook
      python3Packages.unittestCheckHook
    ];

  doInstallCheck = true;

  installCheckTarget = [ "check_install" ];

  unittestFlagsArray = [
    "-s"
    "src/binding/slepc4py/test"
    "-v"
  ];

  pythonImportsCheck = [ "slepc4py" ];

  shellHook = ./setup-hook.sh;

  meta = {
    description = "Scalable Library for Eigenvalue Problem Computations";
    homepage = "https://slepc.upv.es";
    changelog = "https://gitlab.com/slepc/slepc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      bsd2
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
    # Possible error running Fortran src/eps/tests/test7f with 1 MPI process
    broken = stdenv.hostPlatform.isDarwin && withArpack;
  };
})
