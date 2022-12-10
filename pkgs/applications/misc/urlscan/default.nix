{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    hash = "sha256-lCOOVAdsr5LajBGY7XUi4J5pJqm5rOH5IMKhA6fju5w=";
  };

  propagatedBuildInputs = [
    python3Packages.urwid
  ];

  doCheck = false; # No tests available

  pythonImportsCheck = [ "urlscan" ];

  meta = with lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
