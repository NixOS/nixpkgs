{ stdenv, fetchFromGitHub, pkgconfig, cmake, fftwFloat, qt5 }:

stdenv.mkDerivation rec {
  name = "inspectrum-${version}";
  version = "20160103";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "a60d711b46130d37b7c05074285558cd67a28820";
    sha256 = "1q7izpyi7c9qszygiaq0zs3swihxlss3n52q7wx2jq97hdi2hmzy";
  };

  buildInputs = [ pkgconfig cmake qt5.qtbase fftwFloat ];
  
  meta = with stdenv.lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = https://github.com/miek/inspectrum;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
