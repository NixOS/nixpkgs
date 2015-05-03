{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, fftw
, fftwSinglePrec, flac, glibc, glibmm, gtk, gtkmm, jack2
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lv2, makeWrapper, pango
, perl, pkgconfig, python, serd, sord, sratom, suil }:

let

  # Ardour git repo uses a mix of annotated and lightweight tags. Annotated
  # tags are used for MAJOR.MINOR versioning, and lightweight tags are used
  # in-between; MAJOR.MINOR.REV where REV is the number of commits since the
  # last annotated tag. A slightly different version string format is needed
  # for the 'revision' info that is built into the binary; it is the format of
  # "git describe" when _not_ on an annotated tag(!): MAJOR.MINOR-REV-HASH.

  # Version to build.
  tag = "3.5.403";

  # Version info that is built into the binary. Keep in sync with 'tag'. The
  # last 8 digits is a (fake) commit id.
  revision = "3.5-403-00000000";

in

stdenv.mkDerivation rec {
  name = "ardour-${tag}";

  src = fetchgit {
    url = git://git.ardour.org/ardour/ardour.git;
    rev = "refs/tags/${tag}";
    sha256 = "0k1z8sbjf88dqn12kf9cykrqj38vkr879n2g6b4adk6cghn8wz3x";
  };

  buildInputs = 
    [ alsaLib aubio boost cairomm curl fftw fftwSinglePrec flac glibc
      glibmm gtk gtkmm jack2 libgnomecanvas libgnomecanvasmm liblo
      libmad libogg librdf librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lv2
      makeWrapper pango perl pkgconfig python serd sord sratom suil
    ];

  patchPhase = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = \"${revision}\"; }\n' > libs/ardour/revision.cc
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

    # Install desktop file
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/ardour.desktop" << EOF
    [Desktop Entry]
    Name=Ardour 3
    GenericName=Digital Audio Workstation
    Comment=Multitrack harddisk recorder
    Exec=$out/bin/ardour3
    Icon=$out/share/ardour3/icons/ardour_icon_256px.png
    Terminal=false
    Type=Application
    X-MultipleArgs=false
    Categories=GTK;Audio;AudioVideoEditing;AudioVideo;Video;
    EOF
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
