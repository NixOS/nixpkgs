{ lib, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite, libiio
, libbladeRF
, qt5
, USRPSupport ? false, uhd }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TrvyPcpSMACrbKPVOjxHsVsC28LmruiVO/CyCPh0KZ8=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [ hackrf rtl-sdr airspy limesuite libiio libbladeRF ]
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
