{ stdenv, fetchFromGitHub, buildPythonApplication,
click, pyfiglet, dateutil}:

with stdenv.lib;

buildPythonApplication rec {

  name    = "termdown-${version}";
  version = "1.14.1";

  src = fetchFromGitHub {
    rev    = version;
    sha256 = "0jgjzglna0gwp0j31l48pny69szslczl13aahwjfjypkv9lx8w2a";
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
