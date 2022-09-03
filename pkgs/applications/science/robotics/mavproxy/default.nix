{ stdenv, lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0, billiard, gnureadline, opencv4 }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.55";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RS3/U52n1Gs3cJtlZeE5z5q1EmC8NrPFt0mHhvIWVTA=";
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
    opencv4
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
