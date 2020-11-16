{ lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0 }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46c70e013d3e465daae5523f6a1aad553e6ee0f4db137bb935a3273f7ffcc22e";
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
