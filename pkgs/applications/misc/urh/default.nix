{ stdenv, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "1irwrhfbvl3ds8bi69laf8h0fyph0kpwrbfy0q8xh0w3l222sj3m";
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
