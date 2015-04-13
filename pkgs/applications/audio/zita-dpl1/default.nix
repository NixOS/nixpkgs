{ stdenv, fetchurl, jack2, cairo, libpng, libXft, libX11, libclthreads, libclxclient, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "zita-dpl1-${version}";
  version = "0.0.2";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0jgam98nhsxiga5qn42lvkg6gqnz5cxl1n69b36fbcasgvqdc0mf";
  };

  libPath = stdenv.lib.makeLibraryPath [
    libclxclient
  ];

  buildInputs = [
   jack2 cairo libpng libXft libX11 libclthreads libclxclient makeWrapper
  ];

  patchPhase = ''
    cd source
    sed -e "s@/usr/local@$out@" -i Makefile
    sed -e "s@#include <clthreads.h>@#include <${libclthreads}/include>@" -i zita-dpl1.cc
    sed -e "s@#include <clthreads.h>@#include <${libclthreads}/include>@" -i jclient.h
    sed -e "s@#include <clxclient.h>@#include <${libclxclient}/include>@" -i styles.h
    sed -e "s@#include <clxclient.h>@#include <${libclxclient}/include>@" -i rotary.h
    sed -e "s@#include <clxclient.h>@#include <${libclxclient}/include>@" -i mainwin.h
    sed -e "s@#include <clxclient.h>@#include <${libclxclient}/include>@" -i png2img.*
  '';

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS
      -rpath ${libclxclient}
    "
  '';
  postInstall = ''
    wrapProgram $out/bin/zita-dpl1 --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH:${libclxclient}/lib/
  '';

  meta = {
    description = ''
      A look-ahead digital peak limiter, the kind you would use
      as the final step to avoid clipping when mastering or mixing.
    '';
    longDescription = ''
      It can be used as an effect on individual instrument tracks as well.
      Latency is 1.2 ms rounded up to the nearest multiple of 8, 16 or 32
      samples depending on sampling frequency. This amounts to 56 samples at
      44.1 kHz, 64 samples at 48 kHz, and twice those values for 88.2 or 96 kHz.
    '';
    version = "${version}";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/zita-dpl1-doc/quickguide.html";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
