{
  lib,
  fetchPypi,
  makeWrapper,
  python3Packages,
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
python3Packages.buildPythonApplication rec {
  pname = "codechecker";
  version = "6.29.1";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0D8eO+UumjZXh/t00IUcBLtUUwXJINbFaUG+svkOScQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    lxml
    thrift
    sqlalchemy
    prettytable
    multiprocess
    gitpython
    types-pyyaml
    alembic
    psutil
    requests
    types-setuptools
    semver
    pyyaml
    sarif-tools
    argcomplete
    types-psutil
    types-lxml
    authlib
    portalocker
  ];

  pythonRelaxDeps = true;
  nativeBuildInputs = with python3Packages; [
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
    changelog = "https://github.com/Ericsson/codechecker/releases/tag/v${version}";
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
}
