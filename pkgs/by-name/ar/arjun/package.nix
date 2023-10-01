{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "arjun";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "Arjun";
    rev = version;
    hash = "sha256-YxfUlD7aBwoYYsZE0zTZxoXg1TgU2yT1V+mglmsXtlo=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    dicttoxml
  ];

  pythonImportsCheck = [ "arjun" ];

  meta = with lib; {
    description = "HTTP parameter discovery suite";
    homepage = "https://github.com/s0md3v/Arjun";
    changelog = "https://github.com/s0md3v/Arjun/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "arjun";
  };
}
