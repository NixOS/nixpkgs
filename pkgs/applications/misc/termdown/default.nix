{ stdenv, fetchFromGitHub, buildPythonApplication,
click, pyfiglet, dateutil}:

with stdenv.lib;

buildPythonApplication rec {

  name    = "termdown-${version}";
  version = "1.11.0";

  src = fetchFromGitHub {
    rev    = "d1e3504e02ad49013595112cb03fbf175822e58d";
    sha256 = "1i6fxymg52q95n0cbm4imdxh6yvpj3q57yf7w9z5d9pr35cf1iq5";
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
