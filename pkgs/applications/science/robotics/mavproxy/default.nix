{ stdenv, lib, buildPythonApplication, fetchPypi, matplotlib, numpy, pymavlink, pyserial
, setuptools, wxPython_4_0, billiard, gnureadline }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.39";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1RXuAiz9i5ZnLtDGQ+o3DNgWJ2FDJGIoelmlDmEzrts=";
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
