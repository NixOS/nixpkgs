{
  lib,
  python3,
  fetchFromGitHub,
  uv,
  git,
  cargo,
  stdenv,
  darwin,
  nix-update-script,
  testers,
  hatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hatch";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "hatch";
    rev = "refs/tags/hatch-v${version}";
    hash = "sha256-HW2vDVsFrdFRRaPNuGDg9DZpJd8OuYDIqA3KQRa3m9o=";
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
    uv
  ];

  dependencies = with python3.pkgs; [
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
    with python3.pkgs;
    [
      binary
      git
      pytestCheckHook
      pytest-mock
      pytest-xdist
      setuptools
    ]
    ++ [ cargo ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.ps
    ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

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
    ]
    ++ lib.optionals stdenv.isDarwin [
      # https://github.com/NixOS/nixpkgs/issues/209358
      "test_scripts_no_environment"

      # This test assumes it is running on macOS with a system shell on the PATH.
      # It is not possible to run it in a nix build using a /nix/store shell.
      # See https://github.com/pypa/hatch/pull/709 for the relevant code.
      "test_populate_default_popen_kwargs_executable"

      # Those tests fail because the final wheel is named '...2-macosx_11_0_arm64.whl' instead of
      # '...2-macosx_14_0_arm64.whl'
      "test_macos_archflags"
      "test_macos_max_compat"
    ]
    ++ lib.optionals stdenv.isAarch64 [ "test_resolve" ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # AssertionError: assert [call('test h...2p32/bin/sh')] == [call('test h..., shell=True)]
    # At index 0 diff:
    #    call('test hatch-test.py3.10', shell=True, executable='/nix/store/b34ianga4diikh0kymkpqwmvba0mmzf7-bash-5.2p32/bin/sh')
    # != call('test hatch-test.py3.10', shell=True)
    "tests/cli/fmt/test_fmt.py"
    "tests/cli/test/test_test.py"
  ];

  passthru = {
    tests.version = testers.testVersion { package = hatch; };
    updateScript = nix-update-script { };
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
