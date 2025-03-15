{
  lib,
  stdenv,
  cctools,
  fetchurl,
  fetchFromGitLab,
  sowing,
  python3,
  python3Packages,
  gfortran, # will be removed when pr 389036 is merged
  arpack-mpi,
  petsc,
  mpi,
  mpiCheckPhaseHook,
  pythonSupport ? false,
  withExamples ? false,

  # arpack-mpi build failed on aarch64-linux, see pr 390006
  # slepc built with arpack-mpi test failed on darwin platform
  withArpack ? stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux,
}:
assert petsc.mpiSupport;
assert pythonSupport -> petsc.pythonSupport;
stdenv.mkDerivation (finalAttrs: {
  pname = "slepc";
  version = "3.22.2";

  src = fetchFromGitLab {
    owner = "slepc";
    repo = "slepc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a5DmsA7NAlhrEaS43TYPk7vtDfhXLEP+5sftu2A9Yt4=";
  };

  postPatch = ''
    # fix slepc4py install prefix
    substituteInPlace config/packages/slepc4py.py \
      --replace-fail "slepc.prefixdir,'lib'" \
      "slepc.prefixdir,'${python3.sitePackages}'"

    patchShebangs lib/slepc/bin

    # use system bfort
    substituteInPlace config/packages/sowing.py \
      --replace-fail "bfort = os.path.join(archdir,'bin','bfort')" \
      "bfort = '${sowing}/bin/bfort'"
  '';

  preConfigure = ''
    export SLEPC_DIR=$PWD
  '';

  nativeBuildInputs =
    [
      gfortran # will be removed
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

  nativeInstallCheckInputs =
    [
      mpiCheckPhaseHook
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.pythonImportsCheckHook
    ];

  doInstallCheck = true;

  installCheckTarget = [ "check_install" ];

  pythonImportsCheck = [ "slepc4py" ];

  meta = {
    description = "Scalable Library for Eigenvalue Problem Computations";
    homepage = "https://slepc.upv.es";
    changelog = "https://gitlab.com/slepc/slepc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      bsd2
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
    broken = stdenv.hostPlatform.isDarwin && withArpack;
  };
})
