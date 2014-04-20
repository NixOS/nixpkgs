{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, fftw
, fftwSinglePrec, flac, glibc, glibmm, gtk, gtkmm, jackaudio
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lv2, makeWrapper, pango
, perl, pkgconfig, python, serd, sord, sratom, suil }:

let
  tag = "3.5.357";
in

stdenv.mkDerivation rec {
  name = "ardour-${tag}";

  src = fetchgit {
    url = git://git.ardour.org/ardour/ardour.git;
    rev = "refs/tags/${tag}";
    sha256 = "1e026fb9a6ad4179d52c4b578cc3861bdfd3629b9e7b7a7341d431c7d3692c42";
  };

  buildInputs = 
    [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec flac glibc
      glibmm gtk gtkmm jackaudio libgnomecanvas libgnomecanvasmm liblo
      libmad libogg librdf librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lv2
      makeWrapper pango perl pkgconfig python serd sord sratom suil
    ];

  patchPhase = ''
    # The funny revision number is from `git describe rev`
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = \"${tag}-gce4d125\"; }\n' > libs/ardour/revision.cc
    # Note the different version number
    sed -i '33i rev = \"3.5-357-gce4d125\"' wscript
    sed 's|/usr/include/libintl.h|${glibc}/include/libintl.h|' -i wscript
    sed -e 's|^#!/usr/bin/perl.*$|#!${perl}/bin/perl|g' -i tools/fmt-bindings
    sed -e 's|^#!/usr/bin/env.*$|#!${perl}/bin/perl|g' -i tools/*.pl
  '';

  configurePhase = "python waf configure --optimize --prefix=$out";

  buildPhase = "python waf";

  # For the custom ardour clearlooks gtk-engine to work, it must be
  # moved to a directory called "engines" and added to GTK_PATH
  installPhase = ''
    python waf install
    mkdir -pv $out/gtk2/engines
    cp build/libs/clearlooks-newer/libclearlooks.so $out/gtk2/engines/
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
