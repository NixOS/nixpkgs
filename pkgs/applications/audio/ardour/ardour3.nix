{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, fftw
, fftwSinglePrec, flac, glibc, glibmm, gtk, gtkmm, jackaudio
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lv2, makeWrapper, pango
, perl, pkgconfig, python, serd, sord, sratom, suil }:

let
  # Ardour 3.5.308 tag
  rev = "40d8c5ae";
in

stdenv.mkDerivation rec {
  name = "ardour-${version}";
  version = "3.5.308";

  src = fetchgit {
    url = git://git.ardour.org/ardour/ardour.git;
    inherit rev;
    sha256 = "7473c19c2aeb68bd93d512c2d4e976b23dd36d2453c877c859ad37a76f50dc8a";
  };

  buildInputs = 
    [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec flac glibc
      glibmm gtk gtkmm jackaudio libgnomecanvas libgnomecanvasmm liblo
      libmad libogg librdf librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lv2
      makeWrapper pango perl pkgconfig python serd sord sratom suil
    ];

  patchPhase = ''
    # The funny revision number is from `git describe ${rev}
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = \"${version}-g40d8c5a\"; }\n' > libs/ardour/revision.cc
    # Note the different version number
    sed -i '33i rev = \"3.5-308-g40d8c5a\"' wscript
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
