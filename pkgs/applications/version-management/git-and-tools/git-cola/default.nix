{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper, gettext, git }:

let
  inherit (pythonPackages) buildPythonApplication pyqt4 sip pyinotify python mock;
in buildPythonApplication rec {
  name = "git-cola-${version}";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "0jc360agrlhp1w9i725ffksvc6v95jnzzppjvza7ssip65gplrkx";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt4 sip pyinotify ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/git-cola/git-cola;
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
