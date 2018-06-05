{ stdenv, fetchFromGitHub, python3Packages, hackrf, rtl-sdr }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "0i01pj71p3lc1kcqj6mixax6865vbxd9k9jczi2xh4p9nmfa5m2a";
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
