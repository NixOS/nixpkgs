{ lib, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

python3Packages.buildPythonApplication rec {
  pname = "git-cola";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "refs/tags/v${version}";
    hash = "sha256-s+acQo9b+ZQ31qXBf0m8ajXYuYEQzNybmX9nw+c0DQY=";
  };

  buildInputs = [ git gettext ];
  propagatedBuildInputs = with python3Packages; [ pyqt5 qtpy send2trash ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = false;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/git-cola/git-cola";
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
