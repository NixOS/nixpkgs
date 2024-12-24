{
  stdenv,
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  lxml,
  matplotlib,
  numpy,
  opencv-python,
  pymavlink,
  pyserial,
  setuptools,
  wxpython,
  billiard,
  gnureadline,
}:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.71";

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-A7tqV1kBCSuWHJUTdUZGcPY/r7X1edGZs6xDctpMbMI=";
  };

  propagatedBuildInputs =
    [
      lxml
      matplotlib
      numpy
      opencv-python
      pymavlink
      pyserial
      setuptools
      wxpython
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
