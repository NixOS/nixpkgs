{ stdenv, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "06mz35jnmy6rchsnlk2s81fdwnc7zvx496q4ihjb9qybhyka79ay";
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
