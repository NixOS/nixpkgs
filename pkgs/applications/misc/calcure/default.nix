{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calcure";
  version = "3.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "calcure";
    rev = version;
    hash = "sha256-rs3TCZjMndeh2N7e+U62baLs+XqWK1Mk7KVnypSnWPg=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    jdatetime
    holidays
    icalendar
    ics
    attrs
  ];

  pythonImportsCheck = [ "calcure" ];

  meta = with lib; {
    description = "Modern TUI calendar and task manager with minimal and customizable UI";
    homepage = "https://github.com/anufrievroman/calcure";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
