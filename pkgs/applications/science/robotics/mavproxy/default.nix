{ stdenv, lib, buildPythonApplication, fetchPypi, lxml, matplotlib, numpy
, opencv4, pymavlink, pyserial, setuptools, wxPython_4_2, billiard
, gnureadline }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.60";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZDV6ZB95gsdn8BW/VX1pGZeKPLYy0X24IV+hor2Ugeo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "opencv-python" ""
  '';

  propagatedBuildInputs = [
    lxml
    matplotlib
    numpy
    opencv4
    pymavlink
    pyserial
    setuptools
    wxPython_4_2
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
