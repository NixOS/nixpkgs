{ lib
, fetchFromGitHub
, qt5
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      pyqt5 = super.pyqt5.override { withSerialport = true; };
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "mu-editor";
  version = "1.1.0-alpha.2";

  src = fetchFromGitHub {
    owner = "mu-editor";
    repo = "mu";
    rev = "${version}";
    sha256 = "sha256-I38Jy1ArMUKtxCNnAFndA6fpUi0TJP+QJNlU1YzfYL8=";
  };

  patches = [
    ./fix-dependencies.patch
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  propagatedBuildInputs = with python.pkgs; [
    appdirs
    black
    flask
    nudatus
    pgzero
    pycodestyle
    pyflakes
    pyqt5
    pyqtchart
    pyserial
    qscintilla-qt5
    qtconsole
    semver
  ];

  dontWrapQtApps = true;

  doCheck = false;

  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  meta = with lib; {
    description = "A small, simple editor for beginner Python programmers. Written in Python and Qt5.";
    homepage = "https://codewith.mu/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
