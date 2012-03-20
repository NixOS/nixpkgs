{ stdenv, fetchsvn, scons, boost, pkgconfig, fftw, librdf_raptor
, librdf_rasqal, jackaudio, flac, libsamplerate, alsaLib, libxml2
, libxslt, libsndfile, libsigcxx, libusb, cairomm, glib, pango
, gtk, glibmm, gtkmm, libgnomecanvas,  liblo, aubio
, fftwSinglePrec, libmad, automake, autoconf, libtool, liblrdf }:

stdenv.mkDerivation rec {
  name = "ardour-${version}";
  version = "2.8.12";

  # svn is the source to get official releases from their site?
  # alternative: wget  --data-urlencode 'key=7c4b2e1df903aae5ff5cc4077cda801e' http://ardour.org/downloader
  # but hash is changing ?

  # TODO: see if this is also true when using a tag (~goibhniu)

  # This version does not run it exits with the following error:
  # raptor_new_uri_for_rdf_concept called with Raptor V1 world object
  # raptor_general.c:240:raptor_init: fatal error: raptor_init() failedAborted
  src = fetchsvn {
    url = "http://subversion.ardour.org/svn/ardour2/tags/${version}";
    sha256 = "0d4y8bv12kb0yd2srvxn5388sa4cl5d5rk381saj9f3jgpiciyky";
  };

  patchPhase = ''
    sed -e "s#/usr/bin/which#type -P#" -i libs/glibmm2/autogen.sh
    echo '#include "ardour/svn_revision.h"' > libs/ardour/svn_revision.cc
    echo -e 'namespace ARDOUR {\n extern const char* svn_revision = "2.8.12";\n }\n' >> libs/ardour/svn_revision.cc
  '';

  buildInputs = [
    scons boost pkgconfig fftw librdf_raptor librdf_rasqal jackaudio
    flac libsamplerate alsaLib libxml2 libxslt libsndfile libsigcxx
    libusb cairomm glib pango gtk glibmm gtkmm libgnomecanvas liblrdf
    liblo aubio fftwSinglePrec libmad autoconf automake libtool
  ];

  buildPhase = ''
    mkdir -p $out
    export CXX=g++
    scons PREFIX=$out install
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
