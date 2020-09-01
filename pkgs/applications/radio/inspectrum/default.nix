{ lib
, mkDerivation
, fetchFromGitHub
, pkgconfig
, cmake
, boost
, fftwFloat
, gnuradio
, liquid-dsp
, qtbase
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "inspectrum";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "v${version}";
    sha256 = "1a517y7s1xi66y5kjrpjay450pad9nc228pa8801mxq1c7m1lamm";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [
    fftwFloat
    boost
    gnuradio
    liquid-dsp
    qtbase
  ];

  meta = with lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = "https://github.com/miek/inspectrum";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
