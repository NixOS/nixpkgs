{ lib
, python3
, fetchFromGitHub
, qt5
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      pyqt5 = super.pyqt5.override { withSerialPort = true; };
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "mu-editor";
  version = "1.1.0-alpha.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mu-editor";
    repo = "mu";
    rev = version;
    sha256 = "sha256-I38Jy1ArMUKtxCNnAFndA6fpUi0TJP+QJNlU1YzfYL8=";
  };

  nativeBuildInputs = [
    py.pkgs.setuptools
    py.pkgs.wheel
    qt5.wrapQtAppsHook
  ];

  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  propagatedBuildInputs = with py.pkgs; [
    pyqt5
    qscintilla
    pyqtchart
    pycodestyle
    pyflakes
    pyserial
    qtconsole
    pgzero
    appdirs
    semver
    nudatus
    black
    flask
  ];

  pythonImportsCheck = [ "mu" ];

  meta = with lib; {
    description = "A simple Python editor for beginner programmers";
    homepage = "https://github.com/mu-editor/mu";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rookeur ];
    mainProgram = "mu-editor";
  };
}
