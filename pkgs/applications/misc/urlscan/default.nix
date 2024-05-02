{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "urlscan";
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nyq4BrpfbZwK/nOnB8ZEN1wlM8CssYVRvV7ytpX7k40=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = with python3.pkgs; [
    urwid
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "urlscan"
  ];

  meta = with lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
    changelog = "https://github.com/firecat53/urlscan/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dpaetzel ];
    mainProgram = "urlscan";
  };
}
