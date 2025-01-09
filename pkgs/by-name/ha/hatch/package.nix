{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  git,
  cargo,
  versionCheckHook,
  darwin,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "hatch";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "hatch";
    tag = "hatch-v${version}";
    hash = "sha256-JwFPNoFoNqAXkLCGhliLN98VAS+VCwRzo+JqWLIrxsw=";
  };

  patches = [ (replaceVars ./paths.patch { uv = lib.getExe python3Packages.uv; }) ];

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  pythonRemoveDeps = [ "uv" ];

  dependencies = with python3Packages; [
    click
    hatchling
    httpx
    hyperlink
    keyring
    packaging
    pexpect
    platformdirs
    rich
    shellingham
    tomli-w
    tomlkit
    userpath
    virtualenv
    zstandard
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      binary
      git
      pytestCheckHook
      pytest-mock
      pytest-xdist
      setuptools
    ]
    ++ [
      cargo
      versionCheckHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.ps
    ];

  versionCheckProgramArg = [ "--version" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    # AssertionError on the version metadata
    # https://github.com/pypa/hatch/issues/1877
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV21::test_all"
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV21::test_license_expression"
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV22::test_all"
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV22::test_license_expression"
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_all"
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_license_expression"
    "--deselect=tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_license_files"
    "--deselect=tests/backend/metadata/test_spec.py::TestProjectMetadataFromCoreMetadata::test_license_files"
  ];

  disabledTests =
    [
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "test_resolve" ];

  disabledTestPaths =
    [
      # ModuleNotFoundError: No module named 'hatchling.licenses.parse'
      # https://github.com/pypa/hatch/issues/1850
      "tests/backend/licenses/test_parse.py"
      "tests/backend/licenses/test_supported.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # AssertionError: assert [call('test h...2p32/bin/sh')] == [call('test h..., shell=True)]
      # At index 0 diff:
      #    call('test hatch-test.py3.10', shell=True, executable='/nix/store/b34ianga4diikh0kymkpqwmvba0mmzf7-bash-5.2p32/bin/sh')
      # != call('test hatch-test.py3.10', shell=True)
      "tests/cli/fmt/test_fmt.py"
      "tests/cli/test/test_test.py"
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
