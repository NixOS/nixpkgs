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
  version = "1.8.74";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "MAVProxy";
    tag = "v${version}";
    hash = "sha256-1/bp3vlCXt4Hg36zwMKSzPSxW7xlxpfx2o+2uQixdos=";
  };

  propagatedBuildInputs = [
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
