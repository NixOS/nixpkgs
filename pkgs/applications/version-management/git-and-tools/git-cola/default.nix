{ lib, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

let
  inherit (python3Packages) buildPythonApplication pyqt5 sip_4 pyinotify;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "1f8jpfa916nszj431cmp41bxj2m76k2n8qnscqgxrc0k3pnnp3wc";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip_4 pyinotify ];
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
