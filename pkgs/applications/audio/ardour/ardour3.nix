{ stdenv, fetchsvn, alsaLib, aubio, boost, cairomm, curl, fftw
, fftwSinglePrec, flac, glib, glibmm, gtk, gtkmm, jackaudio
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lv2, makeWrapper, pango
, perl, pkgconfig, python, serd, sord, sratom, suil }:

let
  # Ardour 3 Beta 5
  rev = "13072";
in

stdenv.mkDerivation {
  name = "ardour3-svn-${rev}";

  src = fetchsvn {
    url = http://subversion.ardour.org/svn/ardour2/branches/3.0;
    inherit rev;
    sha256 = "17k990kdb5q17z6jcz5b60imvvfbjw9zfxzy9fk0vg8gd6yq7736";
  };

  buildInputs = 
    [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec
      flac glib glibmm gtk gtkmm jackaudio libgnomecanvas
      libgnomecanvasmm liblo libmad libogg librdf librdf_raptor
      librdf_rasqal libsamplerate libsigcxx libsndfile libusb libuuid
      libxml2 libxslt lilv lv2 pango perl pkgconfig python serd sord
      sratom suil
    ];

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
