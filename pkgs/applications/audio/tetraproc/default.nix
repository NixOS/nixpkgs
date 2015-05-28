{ stdenv, fetchurl, fftwFloat, freetype, jack2, libclthreads, libclxclient, libsndfile, x11 }:

stdenv.mkDerivation rec {
  name = "tetraproc-${version}";
  version = "0.8.2";

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "17y3vbm5f6h5cmh3yfxjgqz4xhfwpkla3lqfspnbm4ndlzmfpykv";
  };

  buildInputs = [ jack2 libclthreads libclxclient fftwFloat libsndfile freetype x11 ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  meta = with stdenv.lib; {
    description = "Converts the A-format signals from a tetrahedral Ambisonic microphone into B-format signals ready for recording";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
