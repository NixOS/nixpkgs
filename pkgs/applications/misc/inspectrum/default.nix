{ stdenv
, fetchFromGitHub
, pkgconfig
, cmake
, boost
, fftwFloat
, qt5
, gnuradio
, liquid-dsp
}:

stdenv.mkDerivation rec {
  name = "inspectrum-${version}";
  version = "20170218";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "d8d1969a4cceeee0ebfd2f39e791fddd5155d4de";
    sha256 = "05sarfin9wqkvgwn3fil1r4bay03cwzzhjwbdjslibc5chdrr2cn";
  };

  buildInputs = [
    pkgconfig
    cmake
    qt5.qtbase
    fftwFloat
    boost
    gnuradio
    liquid-dsp
  ];

  meta = with stdenv.lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = https://github.com/miek/inspectrum;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
