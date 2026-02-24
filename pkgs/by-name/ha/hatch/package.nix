{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  git,
  cargo,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  darwin,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "hatch";
  version = "1.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "hatch";
    tag = "hatch-v${version}";
    hash = "sha256-HreVb+RZzQV3p9TaoHDZLHBQFifyH+hocP01u5yU+ms=";
  };

  patches = [ (replaceVars ./paths.patch { uv = lib.getExe python3Packages.uv; }) ];

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  pythonRemoveDeps = [ "uv" ];

  dependencies =
    with python3Packages;
    [
      click
      hatchling
      httpx
      hyperlink
      keyring
      packaging
      pexpect
      platformdirs
      pyproject-hooks
      rich
      shellingham
      tomli-w
      tomlkit
      userpath
      virtualenv
    ]
    ++ lib.optionals (pythonOlder "3.14") [
      backports-zstd
    ];

  nativeCheckInputs =
    with python3Packages;
    [
      binary
      flit-core
      git
      pytestCheckHook
      pytest-mock
      pytest-xdist
      setuptools
    ]
    ++ [
      cargo
      versionCheckHook
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.ps
    ];

  disabledTests = [
    # AssertionError: assert (1980, 1, 2, 0, 0, 0) == (2020, 2, 2, 0, 0, 0)
    "test_default"
    "test_editable_default"
    "test_editable_default_extra_dependencies"
    "test_editable_default_force_include"
    "test_editable_default_force_include_option"
    "test_editable_default_symlink"
    "test_editable_exact"
    "test_editable_exact_extra_dependencies"
    "test_editable_exact_force_include"
    "test_editable_exact_force_include_build_data_precedence"
    "test_editable_exact_force_include_option"
    "test_editable_pth"
    "test_explicit_path"

    # Loosen hatchling runtime version dependency
    "test_core"
    # New failing
    "test_guess_variant"
    "test_open"
    "test_no_open"
    "test_uv_env"
    "test_pyenv"
    "test_pypirc"
    # Relies on FHS
    # Could not read ELF interpreter from any of the following paths: /bin/sh, /usr/bin/env, /bin/dash, /bin/ls
    "test_new_selected_python"

    # https://github.com/pypa/hatch/issues/2006
    "test_project_location_basic_set_first_project"
    "test_project_location_complex_set_first_project"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # This test assumes it is running on macOS with a system shell on the PATH.
    # It is not possible to run it in a nix build using a /nix/store shell.
    # See https://github.com/pypa/hatch/pull/709 for the relevant code.
    "test_populate_default_popen_kwargs_executable"

    # Those tests fail because the final wheel is named '...2-macosx_11_0_arm64.whl' instead of
    # '...2-macosx_14_0_arm64.whl'
    "test_macos_archflags"
    "test_macos_max_compat"

    # https://github.com/pypa/hatch/issues/1942
    "test_features"
    "test_sync_dynamic_dependencies"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "test_resolve" ];

  disabledTestPaths = [
    # httpx.ConnectError: [Errno -3] Temporary failure in name resolution
    "tests/workspaces/test_config.py"

    # additional comment `-*- coding: utf-8 -*-` in output
    "tests/backend/builders/test_sdist.py"

    # missing output `Syncing dependencies`
    "tests/cli/build/test_build.py"
    "tests/cli/project/test_metadata.py"
    "tests/cli/version/test_version.py"

    # AttributeError: 'WheelBuilderConfig' object has no attribute 'sbom_files'
    "tests/backend/builders/test_wheel.py::TestSBOMFiles"

    # some issue with the version of `binary`
    "tests/dep/test_sync.py::test_dependency_not_found"
    "tests/dep/test_sync.py::test_marker_unmet"

    # AssertionError on the version metadata
    # https://github.com/pypa/hatch/issues/1877
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV21::test_all"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV21::test_license_expression"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV22::test_all"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV22::test_license_expression"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_all"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_license_expression"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_license_files"
    "tests/backend/metadata/test_spec.py::TestProjectMetadataFromCoreMetadata::test_license_files"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert [call('test h...2p32/bin/sh')] == [call('test h..., shell=True)]
    # At index 0 diff:
    #    call('test hatch-test.py3.10', shell=True, executable='/nix/store/b34ianga4diikh0kymkpqwmvba0mmzf7-bash-5.2p32/bin/sh')
    # != call('test hatch-test.py3.10', shell=True)
    "tests/cli/fmt/test_fmt.py"
    "tests/cli/test/test_test.py"

    # Dependency/versioning errors in the CLI tests, only seem to show up on Darwin
    # https://github.com/pypa/hatch/issues/1893
    "tests/cli/env/test_create.py::test_sync_dependencies_pip"
    "tests/cli/env/test_create.py::test_sync_dependencies_uv"
    "tests/cli/project/test_metadata.py::TestBuildDependenciesMissing::test_no_compatibility_check_if_exists"
    "tests/cli/run/test_run.py::TestScriptRunner::test_dependencies"
    "tests/cli/run/test_run.py::TestScriptRunner::test_dependencies_from_tool_config"
    "tests/cli/run/test_run.py::test_dependency_hash_checking"
    "tests/cli/run/test_run.py::test_sync_dependencies"
    "tests/cli/run/test_run.py::test_sync_project_dependencies"
    "tests/cli/run/test_run.py::test_sync_project_features"
    "tests/cli/version/test_version.py::test_no_compatibility_check_if_exists"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "hatch-v([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Modern, extensible Python project manager";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/blob/hatch-v${version}/docs/history/hatch.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "hatch";
  };
}
