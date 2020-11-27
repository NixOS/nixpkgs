{ lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0 }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3c704e2d67b36e4932896abe00c89e7f3fb7458fc52849b5d7d6d83bd623adf";
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
