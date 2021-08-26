{ lib
, python3
}:
with python3.pkgs; buildPythonApplication rec {
  pname = "cast_control";
  version = "0.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gsznsd9w8pvbrny0x41wsblgllknvrhcrz3qg1jn7f98phkixas";
  };

  # No tests included
  #doCheck = false;

  propagatedBuildInputs = [
    aiopath
    appdirs
    click
    daemons
    mpris-server
    PyChromecast
  ];

  meta = with lib; {
    homepage = "https://github.com/alexdelorenzo/cast_control/";
    description = "Control Chromecasts from Linux and D-Bus";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
  };
}
