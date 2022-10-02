{ stdenv, lib, buildPythonApplication, fetchPypi, lxml, matplotlib, numpy
, opencv4, pymavlink, pyserial, setuptools, wxPython_4_0, billiard
, gnureadline }:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.56";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wyY9oYWABkXNhlZW4RFuyZy/HEnv7cGFVbXVoEnIF1Q=";
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
