{ stdenv
, fetchFromGitHub
, buildPythonApplication
, click
, pyfiglet
, dateutil
, setuptools
}:

buildPythonApplication rec {
  pname = "termdown";
  version = "1.17.0";

  src = fetchFromGitHub {
    rev = version;
    sha256 = "1sd9z5n2a4ir35832wgxs68vwav7wxhq39b5h8pq934mp8sl3v2k";
    repo = "termdown";
    owner = "trehn";
  };

  propagatedBuildInputs = [ dateutil click pyfiglet setuptools ];

  meta = with stdenv.lib; {
    description = "Starts a countdown to or from TIMESPEC";
    longDescription = "Countdown timer and stopwatch in your terminal";
    homepage = "https://github.com/trehn/termdown";
    license = licenses.gpl3;
  };
}
