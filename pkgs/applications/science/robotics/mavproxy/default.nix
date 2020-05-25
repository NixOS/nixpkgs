{ lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0 }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fi4m3591wws5cq43q8aljf91mzs6i9yhn9rimhpfrskbyf9knvm";
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
