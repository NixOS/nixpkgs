{ stdenv, fetchFromGitHub, python3Packages, hackrf, rtl-sdr }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "1qqb31y65rd85rf3gvxxxy06hm89ary00km1ac84qz5bwm6n5fyb";
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
