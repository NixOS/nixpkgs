{ lib, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

let
  inherit (python3Packages) buildPythonApplication pyqt5 sip_4 pyinotify;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "120hds7v29v70qxz20ppxf2glmgbah16v7jyy9i6hb6cfqp68vr8";
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
