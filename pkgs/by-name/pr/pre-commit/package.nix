{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # tests
  cabal-install,
  cargo,
  gitMinimal,
  go,
  perl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  coursier,
  dotnet-sdk,
  nodejs,

  # passthru
  callPackage,
  pre-commit,
}:

let
  i686Linux = stdenv.buildPlatform.system == "i686-linux";
in
python3Packages.buildPythonApplication rec {
  pname = "pre-commit";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "pre-commit";
    tag = "v${version}";
    hash = "sha256-1IVzeZI4ln5eeArzPhcry6vhZVZj2rp+5D0r1c5ZEA8=";
  };

  patches = [
    ./languages-use-the-hardcoded-path-to-python-binaries.patch
    ./hook-tmpl.patch
    ./pygrep-pythonpath.patch
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    cfgv
    identify
    nodeenv
    pyyaml
    toml
    virtualenv
  ];

  nativeCheckInputs = [
    cabal-install
    cargo
    gitMinimal
    go
    perl
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytest-env
    pytest-forked
    pytest-xdist
    pytestCheckHook
    re-assert
  ])
  ++ lib.optionals (!i686Linux) [
    # coursier can be moved back to the main nativeCheckInputs list once we’re able to bootstrap a
    # JRE on i686-linux: <https://github.com/NixOS/nixpkgs/issues/314873>. When coursier gets
    # moved back to the main nativeCheckInputs list, don’t forget to re-enable the
    # coursier-related test that is currently disabled on i686-linux.
    coursier
    # i686-linux: dotnet-sdk not available
    dotnet-sdk
    # nodejs can be moved back to the main nativeCheckInputs list once this
    # issue is fixed: <https://github.com/NixOS/nixpkgs/issues/387658>. When nodejs gets
    # moved back to the main nativeCheckInputs list, don’t forget to re-enable the
    # Node.js-related tests that are currently disabled on i686-linux.
    nodejs
  ];

  postPatch = ''
    substituteInPlace pre_commit/resources/hook-tmpl \
      --subst-var-by pre-commit $out
    substituteInPlace pre_commit/languages/python.py \
      --subst-var-by virtualenv ${python3Packages.virtualenv}
    substituteInPlace pre_commit/languages/node.py \
      --subst-var-by nodeenv ${python3Packages.nodeenv}

    patchShebangs pre_commit/resources/hook-tmpl
  '';

  pytestFlags = [
    "--forked"
  ];

  preCheck =
    lib.optionalString (!(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64)) ''
      # Disable outline atomics for rust tests on aarch64-linux.
      export RUSTFLAGS="-Ctarget-feature=-outline-atomics"
    ''
    + ''
      export GIT_AUTHOR_NAME=test GIT_COMMITTER_NAME=test \
             GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_EMAIL=test@example.com \
             VIRTUALENV_NO_DOWNLOAD=1 PRE_COMMIT_NO_CONCURRENCY=1
    ''
    + lib.optionalString (!i686Linux) ''
      # Resolve `.NET location: Not found` errors for dotnet tests
      export DOTNET_ROOT="${dotnet-sdk}/share/dotnet"
    ''
    + ''
      git init -b master

      python -m venv --system-site-packages venv
      source "$PWD/venv/bin/activate"
    '';

  postCheck = ''
    deactivate
  '';

  disabledTests = [
    # ERROR: The install method you used for conda--probably either `pip install conda`
    # or `easy_install conda`--is not compatible with using conda as an application.
    "test_conda_"
    "test_local_conda_"

    # /build/pytest-of-nixbld/pytest-0/test_install_ruby_with_version0/rbenv-2.7.2/libexec/rbenv-init:
    # /usr/bin/env: bad interpreter: No such file or directory
    "test_ruby_"

    # network
    "test_additional_dependencies_roll_forward"
    "test_additional_golang_dependencies_installed"
    "test_additional_node_dependencies_installed"
    "test_additional_rust_cli_dependencies_installed"
    "test_additional_rust_lib_dependencies_installed"
    "test_automatic_toolchain_switching"
    "test_coursier_hook"
    "test_coursier_hook_additional_dependencies"
    "test_dart"
    "test_dart_additional_deps"
    "test_dart_additional_deps_versioned"
    "test_during_commit_all"
    "test_golang_default_version"
    "test_golang_hook"
    "test_golang_hook_still_works_when_gobin_is_set"
    "test_golang_infer_go_version_default"
    "test_golang_system"
    "test_golang_versioned"
    "test_language_version_with_rustup"
    "test_installs_rust_missing_rustup"
    "test_installs_without_links_outside_env"
    "test_julia_hook"
    "test_julia_repo_local"
    "test_local_golang_additional_deps"
    "test_lua"
    "test_lua_additional_dependencies"
    "test_node_additional_deps"
    "test_node_hook_versions"
    "test_perl_additional_dependencies"
    "test_r_hook"
    "test_r_inline"
    "test_r_inline_hook"
    "test_r_local_with_additional_dependencies_hook"
    "test_r_with_additional_dependencies_hook"
    "test_run_a_node_hook_default_version"
    "test_run_lib_additional_dependencies"
    "test_run_versioned_node_hook"
    "test_rust_cli_additional_dependencies"
    "test_swift_language"
    "test_run_example_executable"
    "test_run_dep"

    # i don't know why these fail
    "test_install_existing_hooks_no_overwrite"
    "test_installed_from_venv"
    "test_uninstall_restores_legacy_hooks"
    "test_dotnet_"
    "test_health_check_"

    # Expects `git commit` to fail when `pre-commit` is not in the `$PATH`,
    # but we use an absolute path so it's not an issue.
    "test_environment_not_sourced"

    # Docker required
    "test_docker_"
  ]
  ++ lib.optionals i686Linux [
    # From coursier_test.py:
    "test_error_if_no_deps_or_channel"
    # From node_test.py:
    "test_healthy_system_node"
    "test_unhealthy_if_system_node_goes_missing"
    "test_node_hook_system"
    "test_node_with_user_config_set"
  ];

  pythonImportsCheck = [
    "pre_commit"
  ];

  # add gitMinimal as fallback, if git is not installed
  preFixup = ''
    makeWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ gitMinimal ]})
  '';

  passthru.tests = callPackage ./tests.nix {
    inherit gitMinimal pre-commit;
  };

  meta = {
    description = "Framework for managing and maintaining multi-language pre-commit hooks";
    homepage = "https://pre-commit.com/";
    changelog = "https://github.com/pre-commit/pre-commit/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      borisbabic
      savtrip
    ];
    mainProgram = "pre-commit";
  };
}
