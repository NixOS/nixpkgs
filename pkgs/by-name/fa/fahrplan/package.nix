{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "fahrplan";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "fahrplan";
    rev = "refs/tags/v${version}";
    hash = "sha256-2QVaA2zqqFuxjkKbDXo+SNzkrDCxXiSYMUOftQ++wO4=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    python-dateutil
    requests
    texttable
  ];

  meta = {
    description = "Command line access to the SBB/CFF/FFS timetable with human readable argument parsing";
    homepage = "https://github.com/dbrgn/fahrplan";
    changelog = "https://github.com/dbrgn/fahrplan/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ p-h ];
    mainProgram = "fahrplan";
  };
}
