{ stdenv, fetchFromGitHub, buildPythonApplication,
click, pyfiglet, dateutil}:

with stdenv.lib;

buildPythonApplication rec {

  pname = "termdown";
  version = "1.16.0";

  src = fetchFromGitHub {
    rev    = version;
    sha256 = "0k429ss1xifm9vbgyzpp71r79byn9jclvr0rm77bai2r8nz3s2vf";
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
