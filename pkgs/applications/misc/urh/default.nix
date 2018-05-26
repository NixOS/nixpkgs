{ stdenv, fetchFromGitHub, python3Packages, hackrf, rtl-sdr }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "1b796lfwasp02q1340g43z0gmza5y6jn1ga6nb22vfas0yvqpz6p";
  };

  buildInputs = [ hackrf rtl-sdr ];
  propagatedBuildInputs = with python3Packages; [
    pyqt5 numpy psutil cython pyzmq
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
