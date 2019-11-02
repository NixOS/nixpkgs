{ stdenv, fetchzip, autoconf, automake, intltool, pkgconfig, ffmpeg, wxGTK }:

stdenv.mkDerivation rec {
  pname = "spek";
  version = "0.8.3";

  src = fetchzip {
    name = "${pname}-${version}-src";
    url = "https://github.com/alexkay/spek/archive/v${version}.tar.gz";
    sha256 = "0y4hlhswpqkqpsglrhg5xbfy1a6f9fvasgdf336vhwcjqsc3k2xv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake intltool ffmpeg wxGTK ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Analyse your audio files by showing their spectrogram";
    homepage = http://spek.cc/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
