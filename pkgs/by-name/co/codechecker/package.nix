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
  withClang ? false,
  withClangTools ? false,
  withCppcheck ? false,
  withGcc ? false,
}:
python3Packages.buildPythonApplication rec {
  pname = "codechecker";
  version = "6.28.3";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fEAKmvNUHNsa9p2zoHfgoVO+9qGLebvry03PAm3QgTA=";
  };

  patches = [
    (fetchpatch {
      name = "0001-Change-lxml-stubs-to-types-lxml-4966.patch";
      url = "https://github.com/Ericsson/codechecker/commit/4d3dbc7e8248c4b1ddaa3885c26521458712de55.patch";
      hash = "sha256-wWXEzsYaBtP3N+63k6QAkZVHCMM1qhmrUv2QPyM4Xfo=";
    })
  ];

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
    types-lxml
    types-pyyaml
    types-setuptools
    sarif-tools
    types-psutil
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
