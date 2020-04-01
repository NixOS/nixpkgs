{ stdenv, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

let
  inherit (python3Packages) buildPythonApplication pyqt5 sip pyinotify;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "09b60jbpdr4czx7h4vqahqmmi7m9vn77jlkpjfhys7crrdnxjp9i";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip pyinotify ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = false;

  postFixup = ''
    wrapQtApp $out/bin/git-cola
    wrapQtApp $out/bin/git-dag

  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/git-cola/git-cola";
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
