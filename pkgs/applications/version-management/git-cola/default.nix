{ stdenv, lib, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

python3Packages.buildPythonApplication rec {
  pname = "git-cola";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "refs/tags/v${version}";
    hash = "sha256-VAn4zXypOugPIVyXQ/8Yt0rCDM7hVdIY+jpmoTHqssU=";
  };

  buildInputs = [ qt5.qtwayland ];
  propagatedBuildInputs = with python3Packages; [ git pyqt5 qtpy send2trash ];
  nativeBuildInputs = [ gettext qt5.wrapQtAppsHook ];
  nativeCheckInputs = with python3Packages; [ git pytestCheckHook ];

  disabledTestPaths = [
    "qtpy/"
    "contrib/win32"
  ] ++ lib.optionals stdenv.isDarwin [
    "cola/inotify.py"
  ];

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
