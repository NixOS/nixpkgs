{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, fftw
, fftwSinglePrec, flac, glibc, glibmm, gtk, gtkmm, jackaudio
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lv2, makeWrapper, pango
, perl, pkgconfig, python, serd, sord, sratom, suil }:

let
  # Ardour 3.0 tag
  rev = "79db9422";
in

stdenv.mkDerivation {
  name = "ardour3";

  src = fetchgit {
    url = git://git.ardour.org/ardour/ardour.git;
    inherit rev;
    sha256 = "cdbe4ca6d4b639fcd66a3d1cf9c2816b4755655c9d81bdd2417263f413aa7096";
  };

  buildInputs = 
    [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec flac glibc
      glibmm gtk gtkmm jackaudio libgnomecanvas libgnomecanvasmm liblo
      libmad libogg librdf librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lv2
      makeWrapper pango perl pkgconfig python serd sord sratom suil
    ];

  patchPhase = ''
    printf '#include "ardour/svn_revision.h"\nnamespace ARDOUR { const char* svn_revision = \"${rev}\"; }\n' > libs/ardour/svn_revision.cc
    sed -e 's|^#!/usr/bin/perl.*$|#!${perl}/bin/perl|g' -i tools/fmt-bindings
    sed -e 's|^#!/usr/bin/env.*$|#!${perl}/bin/perl|g' -i tools/*.pl
    sed 's|/usr/include/libintl.h|${glibc}/include/libintl.h|' -i wscript
  '';

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  # For the custom ardour clearlooks gtk-engine to work, it must be
  # moved to a directory called "engines" and added to GTK_PATH
  installPhase = ''
    python waf install
    mkdir -pv $out/gtk2/engines
    mv $out/lib/ardour3/libclearlooks.so $out/gtk2/engines/
    wrapProgram $out/bin/ardour3 --prefix GTK_PATH : $out/gtk2
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
