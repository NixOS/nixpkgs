{
  lib,
  pkgs,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "steck";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = "steck";
    tag = "v${version}";
    hash = "sha256-5Spops8ERQ7TgFYH7n+c4hKdIQfjjujKaGhmhfAszgQ=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    pkgs.git
    appdirs
    click
    python-magic
    requests
    termcolor
    toml
  ];

  pythonRelaxDeps = [ "termcolor" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  passthru.tests = nixosTests.pinnwand;

  meta = {
    homepage = "https://github.com/supakeen/steck";
    license = lib.licenses.mit;
    description = "Client for pinnwand pastebin";
    mainProgram = "steck";
    maintainers = with lib.maintainers; [ hexa ];
  };
}
