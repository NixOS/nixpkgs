{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "codechecker-unwrapped";
  version = "6.28.0";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "codechecker";
    hash = "sha256-wxV+/hzsk7RrzWTXNz5HyweYdFFI1upNS508QRPCefo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    alembic
    argcomplete
    authlib
    distutils # required in python312 to call subcommands (see https://github.com/Ericsson/codechecker/issues/4350)
    lxml
    multiprocess
    portalocker
    psutil
    semver
    sqlalchemy
    thrift
    gitpython
    pyyaml
    requests
    types-pyyaml
    sarif-tools
    types-psutil
  ];

  pythonRelaxDeps = true;
  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

  meta = {
    homepage = "https://github.com/Ericsson/codechecker";
    changelog = "https://github.com/Ericsson/codechecker/releases/tag/v${finalAttrs.version}";
    description = "Analyzer tooling, defect database and viewer extension for the Clang Static Analyzer and Clang Tidy";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [
      zebreus
      felixsinger
      kacper-uminski
    ];
    mainProgram = "CodeChecker";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
