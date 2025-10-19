{
  lib,
  stdenv,
  fetchFromGitLab,
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
  version = "3.24.0";

  src = fetchFromGitLab {
    owner = "slepc";
    repo = "slepc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nvzX0p/H3EYR8+7jD+I4FdvU+WstxR/U4Upcn7yZULk=";
  };

  postPatch = ''
    # Fix slepc4py install prefix
    substituteInPlace config/packages/slepc4py.py \
      --replace-fail "slepc.prefixdir,'lib'" \
      "slepc.prefixdir,'${python3Packages.python.sitePackages}'"

    patchShebangs lib/slepc/bin
  '';

  nativeBuildInputs = [
    python3Packages.python
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

  buildInputs = [
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

  nativeInstallCheckInputs = [
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
    changelog = "https://gitlab.com/slepc/slepc/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      bsd2
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
    # Possible error running Fortran src/eps/tests/test7f with 1 MPI process
    broken = stdenv.hostPlatform.isDarwin && withArpack;
  };
})
