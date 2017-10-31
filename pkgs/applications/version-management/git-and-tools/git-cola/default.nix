{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper, gettext, git }:

let
  inherit (pythonPackages) buildPythonApplication pyqt4 sip pyinotify python mock;
in buildPythonApplication rec {
  name = "git-cola-${version}";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "1prv8ib9jdkj5rgixj3hvkivwmbz5xvh8bmllrb1sb301yzi1s0g";
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
