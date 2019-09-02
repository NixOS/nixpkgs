{ stdenv, fetchFromGitHub, pythonPackages, gettext, git, qt5 }:

let
  inherit (pythonPackages) buildPythonApplication pyqt5 sip pyinotify;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "0754d56dprhb1nhb8fwp4my5pyqcgarwzba1l6zx7il87d7vyi5m";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip pyinotify ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = false;

  postFixup = ''
    wrapQtApp bin/git-cola
    wrapQtApp bin/git-dag

  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/git-cola/git-cola;
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
