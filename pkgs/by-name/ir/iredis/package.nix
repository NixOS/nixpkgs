{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iredis";
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laixintao";
    repo = "iredis";
    tag = "v${version}";
    hash = "sha256-ZA4q2Z3X9zhzW/TH8aRliVij8UxqDVUamhKcfVxWb/c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'packaging = "^23.0"' 'packaging = "*"' \
      --replace-fail 'wcwidth = "0.1.9"' 'wcwidth = "*"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    configobj
    mistune
    packaging
    prompt-toolkit
    pygments
    python-dateutil
    redis
    wcwidth
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pexpect
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Fails on sandbox
    "--ignore=tests/unittests/test_client.py"
    "--deselect=tests/unittests/test_render_functions.py::test_render_unixtime_config_raw"
    "--deselect=tests/unittests/test_render_functions.py::test_render_time"
    # Only execute unittests, because cli tests require a running Redis
    "tests/unittests/"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky tests
    "--deselect=tests/unittests/test_entry.py::test_command_shell_options_higher_priority"
    "--deselect=tests/unittests/test_utils.py::test_timer"
  ];

  pythonImportsCheck = [ "iredis" ];

  meta = with lib; {
    description = "Terminal Client for Redis with AutoCompletion and Syntax Highlighting";
    changelog = "https://github.com/laixintao/iredis/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://iredis.xbin.io/";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "iredis";
  };
}
