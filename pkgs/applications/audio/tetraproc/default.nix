{ stdenv, fetchurl, jack2, libclthreads, libclxclient, fftwFloat, libsndfile, freetype, x11
}:

stdenv.mkDerivation rec {
  name = "tetraproc-${version}";
  version = "0.8.2";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "17y3vbm5f6h5cmh3yfxjgqz4xhfwpkla3lqfspnbm4ndlzmfpykv";
  };

  buildInputs = [
   jack2 libclthreads libclxclient fftwFloat libsndfile freetype x11
  ];

  patchPhase = ''
    cd source
    sed -e "s@#include <clthreads.h>@#include <${libclthreads}/include>@" -i tetraproc.cc
    sed -e "s@#include <clxclient.h>@#include <${libclxclient}/include>@" -i *.h
    sed -e "s@#include <clthreads.h>@#include <${libclthreads}/include>@" -i *.h
    sed -e "s@#include <clxclient.h>@#include <${libclxclient}/include>@" -i png2img.*
    sed -e "s@/usr/local@$out@" -i Makefile
  '';

  meta = {
    description = "Converts the A-format signals from a tetrahedral Ambisonic microphone into B-format signals ready for recording";
    version = "${version}";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
