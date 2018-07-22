{ stdenv, fetchFromGitHub, pythonPackages, gettext, git }:

let
  inherit (pythonPackages) buildPythonApplication pyqt5 sip pyinotify;
in buildPythonApplication rec {
  name = "git-cola-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "1xzm8694zndl2pb4nanzhldn7wrsc1gjd5ldjncidw1msp9fczq1";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip pyinotify ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/git-cola/git-cola;
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
