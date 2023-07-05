{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    hash = "sha256-lCOOVAdsr5LajBGY7XUi4J5pJqm5rOH5IMKhA6fju5w=";
  };

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
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
