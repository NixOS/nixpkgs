{ lib
, stdenv
, fetchPypi
, python3
, cargo
, git
, uv
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hatch";
  version = "1.12.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-roBHjRAxLfK0TWWck7wu1NM67N3OS3Y3gjG9+ByL9q0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
    uv
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

  nativeCheckInputs = [
    cargo
  ] ++ (with python3.pkgs; [
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

  disabledTests = [
    # AssertionError: assert (1980, 1, 2, 0, 0, 0) == (2020, 2, 2, 0, 0, 0)
    "test_default"
    # Loosen hatchling runtime version dependency
    "test_core"
    # New failing
    "test_guess_variant"
    "test_open"
    "test_no_open"
    "test_uv_env"
    "test_pyenv"
    "test_pypirc"
  ] ++ lib.optionals stdenv.isDarwin [
    # https://github.com/NixOS/nixpkgs/issues/209358
    "test_scripts_no_environment"

    # This test assumes it is running on macOS with a system shell on the PATH.
    # It is not possible to run it in a nix build using a /nix/store shell.
    # See https://github.com/pypa/hatch/pull/709 for the relevant code.
    "test_populate_default_popen_kwargs_executable"
  ] ++ lib.optionals stdenv.isAarch64 [
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
