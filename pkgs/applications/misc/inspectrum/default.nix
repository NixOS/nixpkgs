{ stdenv, fetchFromGitHub, pkgconfig, cmake, boost, fftwFloat, qt5, gnuradio }:

stdenv.mkDerivation rec {
  name = "inspectrum-${version}";
  version = "20160403";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "27381dbb30f59267a429c04d17d792d3953a6b99";
    sha256 = "0y4j62khq6fcv2qqlqi0kn2ix821m5gcqzg72nhc2zzfb3cdm9nm";
  };

  buildInputs = [ pkgconfig cmake qt5.qtbase fftwFloat boost gnuradio ];
  
  meta = with stdenv.lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = https://github.com/miek/inspectrum;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
