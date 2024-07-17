{
  stdenv,
  lib,
  buildPythonApplication,
  fetchPypi,
  lxml,
  matplotlib,
  numpy,
  opencv4,
  pymavlink,
  pyserial,
  setuptools,
  wxpython,
  billiard,
  gnureadline,
}:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.70";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U5K+0lxJbBvwETnJ3MTMkk47CMOSlJBeFrCLHW9OSh8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "opencv-python" ""
  '';

  propagatedBuildInputs =
    [
      lxml
      matplotlib
      numpy
      opencv4
      pymavlink
      pyserial
      setuptools
      wxpython
    ]
    ++ lib.optionals stdenv.isDarwin [
      billiard
      gnureadline
    ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "MAVLink proxy and command line ground station";
    homepage = "https://github.com/ArduPilot/MAVProxy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
