{ lib
, mkDerivationWith
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "cq-editor";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "CQ-editor";
    rev = version;
    sha256 = "1970izjaa60r5cg9i35rzz9lk5c5d8q1vw1rh2skvfbf63z1hnzv";
  };

  patches = [
    ./spyder4.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    cadquery
    Logbook
    pyqt5
    pyparsing
    pyqtgraph
    spyder
    path
    qtconsole
    requests
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  checkInputs = with python3Packages; [
    pytest
    pytest-xvfb
    pytest-mock
    pytest-cov
    pytest-repeat
    pytest-qt
  ];

  checkPhase = ''
    pytest --no-xvfb
  '';

  # requires X server
  doCheck = false;

  meta = with lib; {
    description = "CadQuery GUI editor based on PyQT";
    homepage = "https://github.com/CadQuery/CQ-editor";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc marcus7070 ];
  };

}
