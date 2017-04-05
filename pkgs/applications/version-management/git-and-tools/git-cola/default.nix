{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper, gettext, git }:

let
  inherit (pythonPackages) buildPythonApplication pyqt4 sip pyinotify python mock;
in buildPythonApplication rec {
  name = "git-cola-${version}";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "067g0yya6718kxagf5qm59zizp0lizca4m3ih85y732i6rqpgwv8";
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
