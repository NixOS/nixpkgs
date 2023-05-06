{ stdenv, lib, buildPythonApplication, fetchPypi, lxml, matplotlib, numpy
, opencv4, pymavlink, pyserial, setuptools, wxPython_4_2, billiard
, gnureadline }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.59";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XY0d9q4nSuPflN4ZX+nT4RKFy6i4Cd2lNWvWaJQzWW8=";
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
