{ fetchgit, stdenv, unzip, pkgconfig, makeWrapper, libsndfile, libmicrohttpd, vim }:

stdenv.mkDerivation rec {

  version = "8-1-2015";
  name = "faust-compiler-${version}";
  src = fetchgit {
    url = git://git.code.sf.net/p/faudiostream/code;
    rev = "4db76fdc02b6aec8d15a5af77fcd5283abe963ce";
    sha256 = "f1ac92092ee173e4bcf6b2cb1ac385a7c390fb362a578a403b2b6edd5dc7d5d0";
  };

  # this version has a bug that manifests when doing faust2jack:
  /*version = "0.9.67";*/
  /*name = "faust-compiler-${version}";*/
  /*src = fetchurl {*/
    /*url = "http://downloads.sourceforge.net/project/faudiostream/faust-${version}.zip";*/
    /*sha256 = "068vl9536zn0j4pknwfcchzi90rx5pk64wbcbd67z32w0csx8xm1";*/
  /*};*/

  buildInputs = [ unzip pkgconfig makeWrapper libsndfile libmicrohttpd vim];


  makeFlags="PREFIX = $(out)";
  FPATH="$out"; # <- where to search

  patchPhase = ''
    sed -i 's@?= $(shell uname -s)@:= Linux@g'  architecture/osclib/oscpack/Makefile
    sed -i 's@faust/misc.h@../../architecture/faust/misc.h@g' tools/sound2faust/sound2faust.cpp
    sed -i 's@faust/gui/@../../architecture/faust/gui/@g' architecture/faust/misc.h
    '';

  buildPhase = ''
    make -C compiler -f Makefile.unix
    make -C architecture/osclib
	g++ -O3 tools/sound2faust/sound2faust.cpp `pkg-config --cflags --static --libs sndfile` -o tools/sound2faust/sound2faust
    make httpd

  '';

  installPhase = ''

    echo install faust itself
    mkdir -p $out/bin/
    mkdir -p $out/include/
	mkdir -p $out/include/faust/
	mkdir -p $out/include/faust/osc/
    install compiler/faust $out/bin/

    echo install architecture and faust library files
    mkdir -p $out/lib/faust
    cp architecture/*.lib $out/lib/faust/
    cp architecture/*.cpp $out/lib/faust/

    echo install math documentation files
	cp architecture/mathdoctexts-*.txt $out/lib/faust/
	cp architecture/latexheader.tex $out/lib/faust/

    echo install additional binary libraries: osc, http
	([ -e architecture/httpdlib/libHTTPDFaust.a ] && cp architecture/httpdlib/libHTTPDFaust.a $out/lib/faust/) || echo libHTTPDFaust not available	
	cp architecture/osclib/*.a $out/lib/faust/
	cp -r architecture/httpdlib/html/js $out/lib/faust/js
	([ -e architecture/httpdlib/src/hexa/stylesheet ] && cp architecture/httpdlib/src/hexa/stylesheet $out/lib/faust/js/stylesheet.js) || echo stylesheet not available
	([ -e architecture/httpdlib/src/hexa/jsscripts ] && cp architecture/httpdlib/src/hexa/jsscripts $out/lib/faust/js/jsscripts.js) || echo jsscripts not available

    echo install includes files for architectures
	cp -r architecture/faust $out/include/

    echo install additional includes files for binary libraries:  osc, http
	cp architecture/osclib/faust/faust/OSCControler.h $out/include/faust/gui/
	cp architecture/osclib/faust/faust/osc/*.h $out/include/faust/osc/
	cp architecture/httpdlib/src/include/*.h $out/include/faust/gui/


    echo patch header and cpp files
    find $out/include/ -name "*.h" -type f | xargs sed "s@#include \"faust/@#include \"$out/include/faust/@g" -i
    find $out/lib/faust/ -name "*.cpp" -type f | xargs sed "s@#include \"faust/@#include \"$out/include/faust/@g" -i
    sed -i "s@../../architecture/faust/gui/@$out/include/faust/gui/@g"  $out/include/faust/misc.h

    wrapProgram $out/bin/faust \
    --set FAUSTLIB $out/lib/faust \
    --set FAUST_LIB_PATH  $out/lib/faust \
    --set FAUSTINC $out/include/
  '';

  meta = with stdenv.lib; {
    description = "A functional programming language for realtime audio signal processing";
    longDescription = ''
      FAUST (Functional Audio Stream) is a functional programming
      language specifically designed for real-time signal processing
      and synthesis. FAUST targets high-performance signal processing
      applications and audio plug-ins for a variety of platforms and
      standards.
      The Faust compiler translates DSP specifications into very
      efficient C++ code. Thanks to the notion of architecture,
      FAUST programs can be easily deployed on a large variety of
      audio platforms and plugin formats (jack, alsa, ladspa, maxmsp,
      puredata, csound, supercollider, pure, vst, coreaudio) without
      any change to the FAUST code.
      This package has just the compiler. Install faust for the full
      set of faust2somethingElse tools.
    '';
    homepage = http://faust.grame.fr/;
    downloadPage = http://sourceforge.net/projects/faudiostream/files/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}

