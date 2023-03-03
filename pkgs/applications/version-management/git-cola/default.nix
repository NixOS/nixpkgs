{ stdenv, lib, fetchFromGitHub, python3Packages, gettext, git, qt5 }:

python3Packages.buildPythonApplication rec {
  pname = "git-cola";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "refs/tags/v${version}";
    hash = "sha256-s+acQo9b+ZQ31qXBf0m8ajXYuYEQzNybmX9nw+c0DQY=";
  };

  # TODO: remove in the next release since upstream removed pytest-flake8
  # https://github.com/git-cola/git-cola/commit/6c5c5c6c888ee1a095fc1ca5521af9a03b833205
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

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
