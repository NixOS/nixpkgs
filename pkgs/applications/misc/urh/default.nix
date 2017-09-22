{ stdenv, fetchFromGitHub, python3Packages, hackrf, rtl-sdr }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "00l1zs3qw89z1hlylprzrpf6nf7h22h0nw43h97gv775vaqqgczv";
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
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
