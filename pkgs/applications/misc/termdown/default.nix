{ stdenv, fetchFromGitHub, buildPythonApplication,
click, pyfiglet, dateutil}:

with stdenv.lib;

buildPythonApplication rec {

  name    = "termdown-${version}";
  version = "1.15.0";

  src = fetchFromGitHub {
    rev    = version;
    sha256 = "08l03yk5jc1g0gps789q1s2knnaqzlidy4s5q5nhwg9g25la19nr";
    repo   = "termdown";
    owner  = "trehn";
  };

  propagatedBuildInputs = [ dateutil click pyfiglet ];

  meta = with stdenv.lib; {
    description     = "Starts a countdown to or from TIMESPEC";
    longDescription = "Countdown timer and stopwatch in your terminal";
    homepage        = https://github.com/trehn/termdown;
    license         = licenses.gpl3;
    platforms       = platforms.all;
  };
}
