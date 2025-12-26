{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  installShellFiles,
  pipenv,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

with python3.pkgs;

let

  runtimeDeps =
    ps:
    with ps;
    [
      certifi
      setuptools
      pip
      virtualenv
      virtualenv-clone
    ]
    ++ lib.optionals stdenv.hostPlatform.isAndroid [
      pyjnius
    ];

  pythonEnv = python3.withPackages runtimeDeps;

in
buildPythonApplication rec {
  pname = "pipenv";
  version = "2025.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipenv";
    tag = "v${version}";
    hash = "sha256-yHbrxhRWo2iD9uBFBQzi5LqUVOc1vpLvXlORtAI32KA=";
  };

  env.LC_ALL = "en_US.UTF-8";

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postPatch = ''
    # pipenv invokes python in a subprocess to create a virtualenv
    # and to call setup.py.
    # It would use sys.executable, which in our case points to a python that
    # does not have the required dependencies.
    substituteInPlace pipenv/utils/virtualenv.py \
      --replace "sys.executable" "'${pythonEnv.interpreter}'"
  '';

  propagatedBuildInputs = runtimeDeps python3.pkgs;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-xdist
    pytest-cov-stub
    pytz
    requests
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # this test wants access to the internet
    "test_download_file"
  ];

  disabledTestPaths = [
    # many of these tests want access to the internet
    "tests/integration"
  ];

  passthru.tests = {
    verify-venv-patch = runCommand "${pname}-test-verify-venv-patch" { } ''
      export PIPENV_VENV_IN_PROJECT=1

      # "pipenv install" should be able to create a venv
      ${pipenv}/bin/pipenv install

       # the venv exists
      [ -d .venv ]

      touch $out
    '';
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pipenv \
      --bash <(_PIPENV_COMPLETE=bash_source $out/bin/pipenv) \
      --zsh <(_PIPENV_COMPLETE=zsh_source $out/bin/pipenv) \
      --fish <(_PIPENV_COMPLETE=fish_source $out/bin/pipenv)
  '';

  meta = {
    description = "Python Development Workflow for Humans";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "pipenv";
  };
}
