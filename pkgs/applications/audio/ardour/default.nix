{ stdenv, fetchurl, scons, boost, pkgconfig, fftw, librdf_raptor2
, librdf_rasqal, jackaudio, flac, libsamplerate, alsaLib, libxml2
, lilv, lv2, serd, sord, sratom, suil # these are probably optional
, libxslt, libsndfile, libsigcxx, libusb, cairomm, glib, pango
, gtk, glibmm, gtkmm, libgnomecanvas, libgnomecanvasmm, liblo, aubio
, fftwSinglePrec, libmad, automake, autoconf, libtool, liblrdf, curl }:

stdenv.mkDerivation rec {
  name = "ardour-${version}";
  version = "2.8.16";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.bz2";
    sha256 = "0h2y0x4yznalllja53anjil2gmgcb26f39zshc4gl1d1kc8k5vip";
  };

  postPatch = ''
    #sed -e "s#/usr/bin/which#type -P#" -i libs/glibmm2/autogen.sh
    echo '#include "ardour/svn_revision.h"' > libs/ardour/svn_revision.cc
    echo -e 'namespace ARDOUR {\n extern const char* svn_revision = "2.8.12";\n }\n' >> libs/ardour/svn_revision.cc
  '';

  buildInputs = [
    scons boost pkgconfig fftw librdf_raptor2 librdf_rasqal jackaudio
    flac libsamplerate alsaLib libxml2 libxslt libsndfile libsigcxx
    #lilv lv2 serd sord sratom suil
    libusb cairomm glib pango gtk glibmm gtkmm libgnomecanvas libgnomecanvasmm liblrdf
    liblo aubio fftwSinglePrec libmad autoconf automake libtool curl
  ];

  buildPhase = ''
    mkdir -p $out
    export CXX=g++
    scons PREFIX=$out SYSLIBS=1 install
  '';

  installPhase = ":";

  meta = {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Broken: use ardour3-svn instead
      Also read "The importance of Paying Something" on their homepage, please!
    '';
    homepage = http://ardour.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
