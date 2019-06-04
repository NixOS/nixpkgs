{ stdenv, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yxv38p8a2srk9c55jj96vcib6m6pb6m485ysfg2ilwjzipx2ab0";
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
