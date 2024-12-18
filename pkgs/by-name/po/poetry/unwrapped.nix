{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  installShellFiles,
  build,
  cachecontrol,
  cleo,
  crashtest,
  dulwich,
  fastjsonschema,
  installer,
  keyring,
  packaging,
  pexpect,
  pkginfo,
  platformdirs,
  poetry-core,
  poetry-plugin-export,
  pyproject-hooks,
  requests,
  requests-toolbelt,
  shellingham,
  tomlkit,
  trove-classifiers,
  virtualenv,
  xattr,
  tomli,
  importlib-metadata,
  deepdiff,
  pytestCheckHook,
  httpretty,
  pytest-mock,
  pytest-xdist,
  darwin,
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.8.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry";
    rev = "refs/tags/${version}";
    hash = "sha256-YR0IgDhmpbe8TyTMP1cjUxGRnrfV8CNHkPlZrNcnof0=";
  };

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  pythonRelaxDeps = [
    "dulwich"
    "keyring"
    "virtualenv"
  ];

  dependencies =
    [
      build
      cachecontrol
      cleo
      crashtest
      dulwich
      fastjsonschema
      installer
      keyring
      packaging
      pexpect
      pkginfo
      platformdirs
      poetry-core
      poetry-plugin-export
      pyproject-hooks
      requests
      requests-toolbelt
      shellingham
      tomlkit
      trove-classifiers
      virtualenv
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      xattr
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      tomli
    ]
    ++ lib.optionals (pythonOlder "3.10") [
      importlib-metadata
    ]
    ++ cachecontrol.optional-dependencies.filecache;

  postInstall = ''
    installShellCompletion --cmd poetry \
      --bash <($out/bin/poetry completions bash) \
      --fish <($out/bin/poetry completions fish) \
      --zsh <($out/bin/poetry completions zsh) \
  '';

  nativeCheckInputs =
    [
      deepdiff
      pytestCheckHook
      httpretty
      pytest-mock
      pytest-xdist
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.ps
    ];

  preCheck = (
    ''
      export HOME=$TMPDIR
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
      # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
      export no_proxy='*';
    ''
  );

  postCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    unset no_proxy
  '';

  disabledTests = [
    "test_builder_should_execute_build_scripts"
    "test_env_system_packages_are_relative_to_lib"
    "test_executor_known_hashes"
    "test_install_warning_corrupt_root"
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

  # Unset ambient PYTHONPATH in the wrapper, so Poetry only ever runs with its own,
  # isolated set of dependencies. This works because the correct PYTHONPATH is set
  # in the Python script, which runs after the wrapper.
  makeWrapperArgs = [ "--unset PYTHONPATH" ];

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [
      jakewaksbaum
      dotlambda
    ];
    mainProgram = "poetry";
  };
}
