{ stdenv, lib, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite, libiio
, qt5
, USRPSupport ? false, uhd }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "v${version}";
    sha256 = "0axzqyljbmpc4c9bnqmdrrz5la5r9qynp49fig645xyxs87vq6b0";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [ hackrf rtl-sdr airspy limesuite libiio ]
    ++ lib.optional USRPSupport uhd;

  propagatedBuildInputs = with python3Packages; [
    pyqt5 numpy psutil cython pyzmq pyaudio setuptools
  ];

  postFixup = ''
    wrapQtApp $out/bin/urh
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
