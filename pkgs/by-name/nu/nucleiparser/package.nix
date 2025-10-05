{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nucleiparser";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sinkmanu";
    repo = "nucleiparser";
    tag = version;
    hash = "sha256-/SLaRuO06rF7aLV7zY7tfIxkJRzsx+/Z+mc562RX2OQ=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    prettytable
  ];

  pythonImportsCheck = [
    "nucleiparser"
  ];

  meta = {
    description = "Nuclei output parser for CLI";
    homepage = "https://github.com/sinkmanu/nucleiparser";
    changelog = "https://github.com/Sinkmanu/nucleiparser/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nparser";
  };
}
