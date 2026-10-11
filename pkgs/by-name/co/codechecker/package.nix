{
  lib,
  fetchpatch,
  fetchPypi,
  makeWrapper,
  python313Packages,
  libclang,
  clang-tools,
  cppcheck,
  gcc,
  infer,
  withClang ? false,
  withClangTools ? false,
  withCppcheck ? false,
  withGcc ? false,
  withInfer ? false,
}:
# Starting the codechecker server currently breaks with Python 3.14
# https://github.com/Ericsson/codechecker/issues/4773
python313Packages.buildPythonApplication (finalAttrs: {
  pname = "codechecker";
  version = "6.29.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0D8eO+UumjZXh/t00IUcBLtUUwXJINbFaUG+svkOScQ=";
  };

  build-system = with python313Packages; [
    setuptools
    types-setuptools
  ];

  dependencies = with python313Packages; [
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
    types-lxml
    prettytable
  ];

  pythonRelaxDeps = true;
  nativeBuildInputs = with python313Packages; [
    makeWrapper
    pythonRelaxDepsHook
  ];

  postInstall = ''
    wrapProgram "$out/bin/CodeChecker" --prefix PATH : ${
      lib.makeBinPath (
        lib.optional withClang libclang
        ++ lib.optional withClangTools clang-tools
        ++ lib.optional withCppcheck cppcheck
        ++ lib.optional withGcc gcc
        ++ lib.optional withInfer infer
      )
    }
  '';

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
