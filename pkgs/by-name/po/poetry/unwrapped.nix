{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  findpython,
  installShellFiles,
  build,
  cachecontrol,
  cleo,
  dulwich,
  fastjsonschema,
  installer,
  keyring,
  packaging,
  pbs-installer,
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
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry";
    tag = version;
    hash = "sha256-oPHRDYci4lrZBY3MC4QU1juwbMJYFDJjARg1Y8us4FQ=";
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
  ];

  dependencies = [
    build
    cachecontrol
    cleo
    dulwich
    fastjsonschema
    findpython
    installer
    keyring
    packaging
    pbs-installer
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
  ++ cachecontrol.optional-dependencies.filecache
  ++ pbs-installer.optional-dependencies.download
  ++ pbs-installer.optional-dependencies.install;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd poetry \
      --bash <($out/bin/poetry completions bash) \
      --fish <($out/bin/poetry completions fish) \
      --zsh <($out/bin/poetry completions zsh) \
  '';

  nativeCheckInputs = [
    deepdiff
    pytestCheckHook
    httpretty
    pytest-mock
    pytest-xdist
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
    "test_no_additional_output_in_verbose_mode"
    "test_project_plugins_are_installed_in_project_folder"
    "test_application_command_not_found_messages"
    # PermissionError: [Errno 13] Permission denied: '/build/pytest-of-nixbld/pytest-0/popen-gw3/test_find_poetry_managed_pytho1/.local/share/pypoetry/python/pypy@3.10.8/bin/python'
    "test_list_poetry_managed"
    "test_list_poetry_managed"
    "test_find_all_with_poetry_managed"
    "test_find_poetry_managed_pythons"
    # Flaky
    "test_threading_property_types"
    "test_threading_single_thread_safe"
    "test_threading_property_caching"
    "test_threading_atomic_cached_property_different_instances"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Sandbox violation:
    # PermissionError: [Errno 1] Operation not permitted: '/Library/Frameworks/Python.framework/Versions'
    "test_find_all"
  ];

  disabledTestMarks = [
    "network"
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

  # Unset ambient PYTHONPATH in the wrapper, so Poetry only ever runs with its own,
  # isolated set of dependencies. This works because the correct PYTHONPATH is set
  # in the Python script, which runs after the wrapper.
  makeWrapperArgs = [ "--unset PYTHONPATH" ];

  meta = {
    changelog = "https://github.com/python-poetry/poetry/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jakewaksbaum
      dotlambda
    ];
    mainProgram = "poetry";
  };
}
