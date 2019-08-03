{ stdenv, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jrrj9c4ddm37m8j0g693xjimpnlvx7lan5kxish5p14xpwdak35";
  };

  buildInputs = [ hackrf rtl-sdr airspy limesuite ];
  propagatedBuildInputs = with python3Packages; [
    pyqt5 numpy psutil cython pyzmq
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
