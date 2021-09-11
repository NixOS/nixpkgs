{ stdenv, lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0, billiard, gnureadline }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.41";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dffb9b5b1e23c8dcb54bb8bdf1435337c01a4ab9faf34ffdfcb1dd26a4d8890";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "opencv-python" ""
  '';

  propagatedBuildInputs = [
    matplotlib
    numpy
    pymavlink
    pyserial
    setuptools
    wxPython_4_0
  ] ++ lib.optionals stdenv.isDarwin [ billiard gnureadline ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "MAVLink proxy and command line ground station";
    homepage = "https://github.com/ArduPilot/MAVProxy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
