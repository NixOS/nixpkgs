{
  lib,
  stdenv,
  fetchPypi,
  python3,
  cargo,
  git,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hatch";
  version = "1.9.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gae4IXn5Tyrd2612qn5lq5DK1VqxA9U4J2N5NcnmYkw=";
  };

  postPatch = ''
    # Loosen hatchling runtime version dependency
    sed -i 's/hatchling<1.22/hatchling/' pyproject.toml
  '';

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
    [
      cargo
    ]
    ++ (with python3.pkgs; [
      binary
      git
      pytestCheckHook
      pytest-mock
      pytest-xdist
      setuptools
    ]);

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests =
    [
      # AssertionError: assert (1980, 1, 2, 0, 0, 0) == (2020, 2, 2, 0, 0, 0)
      "test_default"
      "test_explicit_path"
      "test_default_auto_detection"
      "test_editable_default"
      "test_editable_default_extra_dependencies"
      "test_editable_default_force_include"
      "test_editable_default_force_include_option"
      "test_editable_exact"
      "test_editable_exact_extra_dependencies"
      "test_editable_exact_force_include"
      "test_editable_exact_force_include_option"
      "test_editable_exact_force_include_build_data_precedence"
      "test_editable_pth"
      # expects sh, finds bash
      "test_all"
      "test_already_installed_update_flag"
      "test_already_installed_update_prompt"
      # Loosen hatchling runtime version dependency
      "test_core"
      "test_correct"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # https://github.com/NixOS/nixpkgs/issues/209358
      "test_scripts_no_environment"

      # This test assumes it is running on macOS with a system shell on the PATH.
      # It is not possible to run it in a nix build using a /nix/store shell.
      # See https://github.com/pypa/hatch/pull/709 for the relevant code.
      "test_populate_default_popen_kwargs_executable"
    ]
    ++ lib.optionals stdenv.isAarch64 [
      "test_resolve"
    ];

  meta = with lib; {
    description = "Modern, extensible Python project manager";
    mainProgram = "hatch";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/blob/hatch-v${version}/docs/history/hatch.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
