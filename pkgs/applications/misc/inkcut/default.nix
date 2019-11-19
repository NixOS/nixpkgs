{ lib, python3Packages, fetchFromGitHub, wrapQtAppsHook }:

with python3Packages;

buildPythonApplication rec {
  pname = "inkcut";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0g2vix80rvk3xh90vh7r5mw4nyja2z9fy8x0g72mgjbk6l6afs5x";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [
    enamlx
    twisted
    lxml
    qt-reactor
    jsonpickle
    pyserial
    pycups
    qtconsole
    pyqt5
  ];

  # QtApplication.instance() does not work during tests?
  doCheck = false;

  postFixup = ''
    wrapQtApp $out/bin/inkcut
  '';


  meta = with lib; {
    homepage = https://www.codelv.com/projects/inkcut/;
    description = "Control 2D plotters, cutters, engravers, and CNC machines";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raboof ];
  };
}
