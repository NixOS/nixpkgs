{ lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0 }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f5900dc0a404ab9cf5a00155f83e9aaeab18161ce21a352dfdcf2d7abf5d78e";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pymavlink
    pyserial
    setuptools
    wxPython_4_0
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "MAVLink proxy and command line ground station";
    homepage = "https://github.com/ArduPilot/MAVProxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
