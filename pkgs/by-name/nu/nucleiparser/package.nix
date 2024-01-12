{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nucleiparser";
  version = "unstable-2023-12-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sinkmanu";
    repo = "nucleiparser";
    # https://github.com/Sinkmanu/nucleiparser/issues/1
    rev = "42f3d57c70300c436497c2539cdb3c49977fc48d";
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

  meta = with lib; {
    description = "A Nuclei output parser for CLI";
    homepage = "https://github.com/sinkmanu/nucleiparser";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "nparser";
  };
}
