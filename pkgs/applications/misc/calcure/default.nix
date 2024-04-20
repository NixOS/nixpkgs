{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calcure";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "calcure";
    rev = "refs/tags/${version}";
    hash = "sha256-rs3TCZjMndeh2N7e+U62baLs+XqWK1Mk7KVnypSnWPg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    holidays
    icalendar
    jdatetime
    taskw
  ];

  pythonImportsCheck = [
    "calcure"
  ];

  meta = with lib; {
    description = "Modern TUI calendar and task manager with minimal and customizable UI";
    mainProgram = "calcure";
    homepage = "https://github.com/anufrievroman/calcure";
    changelog = "https://github.com/anufrievroman/calcure/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
