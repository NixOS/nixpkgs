{ lib, stdenv, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

let
  inherit (python3Packages) buildPythonApplication pyqt5 sip pyinotify;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "1qxv2k8lxcxpqx46ka7f042xk90xns5w9lc4009cxmsqvcdba03a";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip pyinotify ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = false;

  postFixup = ''
    wrapQtApp $out/bin/git-cola
    wrapQtApp $out/bin/git-dag

  '';

  meta = with lib; {
    homepage = "https://github.com/git-cola/git-cola";
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
