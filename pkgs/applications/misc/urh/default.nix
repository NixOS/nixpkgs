{ stdenv, fetchFromGitHub, python3Packages, hackrf, rtl-sdr }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "0mnnrxm49s77s1qg7zbfciw0525ipsl010sciqdw8a22jg1rfjh8";
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
