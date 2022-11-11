{ lib, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

let
  inherit (python3Packages) buildPythonApplication pyqt5 sip_4 pyinotify qtpy;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "refs/tags/v${version}";
    hash = "sha256-w3SbuquHuWTYg1N3kcix4S5vrsmclVSrHf6uv8CYU6w=";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip_4 pyinotify qtpy ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = false;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/git-cola/git-cola";
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
