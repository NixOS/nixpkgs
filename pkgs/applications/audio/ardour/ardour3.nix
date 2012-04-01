{ stdenv, fetchsvn, alsaLib, aubio, boost, cairomm, curl, fftw
, fftwSinglePrec, flac, glib, glibmm, gtk, gtkmm, jackaudio
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, makeWrapper, pango, perl, pkgconfig
, python }:

let
  rev = "11483";
in

stdenv.mkDerivation {
  name = "ardour3-svn-${rev}";

  src = fetchsvn {
    url = http://subversion.ardour.org/svn/ardour2/tags/3.0-beta3;
    inherit rev;
    sha256 = "02az11lvfbln475np9jyfkdlrkpp1pszjmk6gl75wq6ws08dd7rd";
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

  postInstall = ''
    mkdir -pv $out/gtk-2.0/2.10.0/engines
    mv lib/ardour3/libclearlooks.so $out/gtk-2.0/2.10.0/engines/
    wrapProgram $out/bin/ardour3 --prefix GTK_PATH : $out/gtk-2.0
    '';

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
