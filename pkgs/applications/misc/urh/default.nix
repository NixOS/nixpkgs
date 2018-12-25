{ stdenv, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "01n4swm2q2i10qvhfw1q04wxf48xwqlddfg7842ff98i2d9yxy13";
  };

  buildInputs = [ hackrf rtl-sdr airspy limesuite ];
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
