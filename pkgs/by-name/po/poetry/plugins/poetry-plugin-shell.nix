{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  stdenv,
  pexpect,
  poetry,
  poetry-core,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  shellingham,
  darwin,
}:

buildPythonPackage rec {
  pname = "poetry-plugin-shell";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-plugin-shell";
    tag = version;
    hash = "sha256-BntObwrW7xt1gYWpckLJF7GklkmUJMh8D1IUwCcOOl4=";
  };

  build-system = [ poetry-core ];

  buildInputs = [
    poetry
  ];

  dependencies = [
    pexpect
    shellingham
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.ps
  ];

  meta = {
    changelog = "https://github.com/python-poetry/poetry-plugin-shell/blob/${src.tag}/CHANGELOG.md";
    description = "Poetry plugin to run subshell with virtual environment activated";
    homepage = "https://github.com/python-poetry/poetry-plugin-shell";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
