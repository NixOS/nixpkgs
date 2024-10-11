{
  lib,
  python3,
  fetchFromGitHub,
  litecli,
  frida-tools,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "objection";
  version = "1.11.0-unstable-2024-09-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "objection";
    rev = "5f22e0acf7dd8fb9d3c1610629339e4fd422557d";
    hash = "sha256-kLv13N6YcUYfLG6VXW2aBmkm+9bEkTQjqqGjOiRo8b8=";
  };

  pythonRelaxDeps = [
    "semver"
  ];

  dependencies = with python3.pkgs; [
    setuptools
    frida-python
    prompt-toolkit
    click
    tabulate
    semver
    delegator-py
    requests
    flask
    pygments
  ];

  propagatedBuildInputs = [
    frida-tools
    litecli
  ];

  meta = with lib; {
    description = "Runtime mobile exploration toolkit, powered by Frida";
    homepage = "https://github.com/sensepost/objection";
    license = licenses.gpl3;
    maintainers = with maintainers; [ exploitoverload ];
    mainProgram = "objection";
  };
}
