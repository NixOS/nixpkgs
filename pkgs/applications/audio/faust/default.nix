{ fetchgit, stdenv, bash, alsaLib, atk, cairo, faust-compiler, fontconfig, freetype
, gcc, gdk_pixbuf, glib, gtk, jack2, makeWrapper, opencv, pango, pkgconfig, unzip
, gtkSupport ? true
, jackaudioSupport ? true
}:

stdenv.mkDerivation rec {

  version = "8-1-2015";
  name = "faust-${version}";
  src = fetchgit {
    url = git://git.code.sf.net/p/faudiostream/code;
    rev = "4db76fdc02b6aec8d15a5af77fcd5283abe963ce";
    sha256 = "f1ac92092ee173e4bcf6b2cb1ac385a7c390fb362a578a403b2b6edd5dc7d5d0";
  };

  # this version has a bug that manifests when doing faust2jack:
  /*version = "0.9.67";*/
  /*name = "faust-${version}";*/
  /*src = fetchurl {*/
    /*url = "http://downloads.sourceforge.net/project/faudiostream/faust-${version}.zip";*/
    /*sha256 = "068vl9536zn0j4pknwfcchzi90rx5pk64wbcbd67z32w0csx8xm1";*/
  /*};*/

  buildInputs = [ bash unzip faust-compiler gcc makeWrapper pkgconfig ]
    ++ stdenv.lib.optionals gtkSupport [
      alsaLib atk cairo fontconfig freetype gdk_pixbuf glib gtk pango
    ]
    ++ stdenv.lib.optional jackaudioSupport jack2
  ;

  makeFlags="PREFIX=$(out)";
  FPATH="$out"; # <- where to search

  phases = [ "unpackPhase installPhase postInstall" ];

  installPhase  = ''
    sed -i 23,24d  tools/faust2appls/faust2jack
    mkdir $out/bin
    install tools/faust2appls/faust2alsaconsole $out/bin
    install tools/faust2appls/faustpath  $out/bin
    install tools/faust2appls/faustoptflags  $out/bin
    install tools/faust2appls/faust2alsa $out/bin
    install tools/faust2appls/faust2jack $out/bin

    patchShebangs $out/bin

    wrapProgram $out/bin/faust2alsaconsole \
    --prefix PKG_CONFIG_PATH : ${alsaLib}/lib/pkgconfig \
    --set FAUSTLIB ${faust-compiler}/lib/faust \
    --set FAUSTINC ${faust-compiler}/include/

    GTK_PKGCONFIG_PATHS=${gtk}/lib/pkgconfig:${pango}/lib/pkgconfig:${glib}/lib/pkgconfig:${cairo}/lib/pkgconfig:${gdk_pixbuf}/lib/pkgconfig:${atk}/lib/pkgconfig:${freetype}/lib/pkgconfig:${fontconfig}/lib/pkgconfig

    wrapProgram  $out/bin/faust2alsa \
    --prefix PKG_CONFIG_PATH :  ${alsaLib}/lib/pkgconfig:$GTK_PKGCONFIG_PATHS \
    --set FAUSTLIB ${faust-compiler}/lib/faust \
    --set FAUSTINC ${faust-compiler}/include/ \


    wrapProgram  $out/bin/faust2jack \
    --prefix PKG_CONFIG_PATH :  ${jack2}/lib/pkgconfig:${opencv}/lib/pkgconfig:$GTK_PKGCONFIG_PATHS \
    --set FAUSTLIB ${faust-compiler}/lib/faust \
    --set FAUSTINC ${faust-compiler}/include/ \

    ''
    + stdenv.lib.optionalString (!gtkSupport) "rm $out/bin/faust2alsa"
    + stdenv.lib.optionalString (!gtkSupport || !jackaudioSupport) "rm $out/bin/faust2jack"
  ;
  postInstall = ''
    sed -e "s@\$FAUST_INSTALL /usr/local /usr /opt /opt/local@${faust-compiler}@g" -i $out/bin/faustpath
    sed -i "s@/bin/bash@${bash}/bin/bash@g" $out/bin/faustoptflags
    find $out/bin/ -name "*faust2*" -type f | xargs sed "s@pkg-config@${pkgconfig}/bin/pkg-config@g" -i
    find $out/bin/ -name "*faust2*" -type f | xargs sed "s@CXX=g++@CXX=${gcc}/bin/g++@g" -i
    find $out/bin/ -name "*faust2*" -type f | xargs sed "s@faust -i -a @${faust-compiler}/bin/faust -i -a ${faust-compiler}/lib/faust/@g" -i
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
    '';
    homepage = http://faust.grame.fr/;
    downloadPage = http://sourceforge.net/projects/faudiostream/files/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}

