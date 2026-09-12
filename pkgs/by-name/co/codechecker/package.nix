{
  lib,
  fetchpatch,
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
  version = "6.28.2";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # Change lxml-stubs to types-lxml
    (fetchpatch {
      url = "https://github.com/Ericsson/codechecker/commit/4d3dbc7e8248c4b1ddaa3885c26521458712de55.patch";
      hash = "sha256-wWXEzsYaBtP3N+63k6QAkZVHCMM1qhmrUv2QPyM4Xfo=";
    })
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ZmrY/fEPW+hm4sPyXEHOu0T2x0ruRMKhOGwSSVFbfc=";
  };

  build-system = with python3Packages; [
    setuptools
    types-setuptools
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
    types-lxml
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
