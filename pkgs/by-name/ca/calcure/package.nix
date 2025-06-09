{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calcure";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "calcure";
    tag = version;
    hash = "sha256-YFX70gtNcIXG5XIuMlz47nmtjt/2oHzi6cajcj+DAyQ=";
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
    changelog = "https://github.com/anufrievroman/calcure/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
