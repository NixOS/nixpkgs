{ stdenv, fetchsvn, alsaLib, aubio, boost, cairomm, curl, fftw,
fftwSinglePrec, flac, glib, glibmm, gtk, gtkmm, jackaudio,
libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf,
librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile,
libusb, libuuid, libxml2, libxslt, pango, perl, pkgconfig, python }:

let
  rev = "9484";
in

stdenv.mkDerivation {
  name = "ardour-3.0-${rev}";

  src = fetchsvn {
    url = http://subversion.ardour.org/svn/ardour2/branches/3.0;
    inherit rev;
    sha256 = "13j490kw66sslxibfab8hmm2k6gapvsriqa4av02y438dr1k4skf";
  };

  buildInputs = [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec
    flac glib glibmm gtk gtkmm jackaudio libgnomecanvas
    libgnomecanvasmm liblo libmad libogg librdf librdf_raptor
    librdf_rasqal libsamplerate libsigcxx libsndfile libusb libuuid
    libxml2 libxslt pango perl pkgconfig python ];

  patchPhase = ''
    printf '#include "ardour/svn_revision.h"\nnamespace ARDOUR { const char* svn_revision = \"${rev}\"; }\n' > libs/ardour/svn_revision.cc
    sed -e 's|^#!/usr/bin/perl.*$|#!${perl}/bin/perl|g' -i tools/fmt-bindings
    sed -e 's|^#!/usr/bin/env.*$|#!${perl}/bin/perl|g' -i tools/*.pl
  '';

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Also read "The importance of Paying Something" on their homepage, please!
    '';
    homepage = http://ardour.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
