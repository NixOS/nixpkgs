{ stdenv, fetchFromGitHub, pythonPackages, gettext, git }:

let
  inherit (pythonPackages) buildPythonApplication pyqt5 sip pyinotify;
in buildPythonApplication rec {
  name = "git-cola-${version}";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "1ivaqhvdbmlp0lmrwb2pv3kjqlcpqbxbinbvjjn3g81r4avjs7yy";
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
