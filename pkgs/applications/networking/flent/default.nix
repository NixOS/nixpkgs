{ stdenv, buildPythonApplication, fetchFromGitHub, matplotlib, netperf, procps, pyqt5 }:

buildPythonApplication rec {
  pname = "flent";
  version = "1.2.2";
  src = fetchFromGitHub {
    owner = "tohojo";
    repo = "flent";
    rev = version;
    sha256 = "0rl4ahynl6ymw7r04vpg9p90pplrxc41rjlzvm0swxsvpw40yvkm";
  };

  buildInputs = [ netperf ];
  propagatedBuildInputs = [
    matplotlib
    procps
    pyqt5
  ];

  meta = with stdenv.lib; {
    description = "The FLExible Network Tester";
    homepage = https://flent.org;
    license = licenses.gpl3;

    maintainers = [ maintainers.mmlb ];
  };
}
