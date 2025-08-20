{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch2,
  installShellFiles,
  build,
  cachecontrol,
  cleo,
  dulwich,
  fastjsonschema,
  installer,
  keyring,
  packaging,
  pkginfo,
  platformdirs,
  poetry-core,
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
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry";
    tag = version;
    hash = "sha256-r4TK4CKDfCeCW+Y1vUoS4ppXmn5xEvI1ZBVUHqFJLKo=";
  };

  patches = [
    # https://github.com/python-poetry/poetry/pull/9939
    (fetchpatch2 {
      url = "https://github.com/python-poetry/poetry/commit/89c0d02761229a8aa7ac5afcbc8935387bde4c5b.patch?full_index=1";
      hash = "sha256-YuAevkmCSTGuFPfuKrJfcLUye1YGpnHSb9TFSW7F1SU=";
    })
  ];

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
      dulwich
      fastjsonschema
      installer
      keyring
      packaging
      pkginfo
      platformdirs
      poetry-core
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
    "test_install_warning_corrupt_root"
    "test_project_plugins_are_installed_in_project_folder"
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
