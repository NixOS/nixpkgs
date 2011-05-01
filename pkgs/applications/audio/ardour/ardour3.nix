{ stdenv, fetchsvn, alsaLib, aubio, boost, cairomm, curl, fftw,
fftwSinglePrec, flac, glib, glibmm, gtk, gtkmm, jackaudio,
libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf,
librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile,
libusb, libuuid, libxml2, libxslt, pango, perl, pkgconfig, python }:

stdenv.mkDerivation {
  name = "ardour-3.0-alpha2";

  src = fetchsvn {
    url = http://subversion.ardour.org/svn/ardour2/tags/3.0-alpha2;
    rev = 9198;
    sha256 = "1ghz1fd07bpp2696z0yx3ci787c7wh0bwnbrpjhx2hx0zl3brc1h";
  };

  buildInputs = [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec
    flac glib glibmm gtk gtkmm jackaudio libgnomecanvas
    libgnomecanvasmm liblo libmad libogg librdf librdf_raptor
    librdf_rasqal libsamplerate libsigcxx libsndfile libusb libuuid
    libxml2 libxslt pango perl pkgconfig python ];

  patchPhase = ''
    printf '#include "ardour/svn_revision.h"\nnamespace ARDOUR { const char* svn_revision = \"9198\"; }\n' > libs/ardour/svn_revision.cc
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
