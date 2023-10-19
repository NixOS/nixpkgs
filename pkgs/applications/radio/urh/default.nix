{ lib, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite, libiio
, libbladeRF
, qt5
, USRPSupport ? false, uhd }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Hi0VqBtGeaXMsibxbHk+2FN8mzfpmkuDr37JRW4Fp+s=";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
