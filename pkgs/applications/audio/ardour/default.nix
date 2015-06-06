{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, doxygen, dbus, fftw
, fftwSinglePrec, flac, glibc, glibmm, graphviz, gtk, gtkmm, jack2
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv-svn, lv2, makeWrapper, pango
, perl, pkgconfig, python, rubberband, serd, sord-svn, sratom, suil, taglib, vampSDK }:

let

  # Ardour git repo uses a mix of annotated and lightweight tags. Annotated
  # tags are used for MAJOR.MINOR versioning, and lightweight tags are used
  # in-between; MAJOR.MINOR.REV where REV is the number of commits since the
  # last annotated tag. A slightly different version string format is needed
  # for the 'revision' info that is built into the binary; it is the format of
  # "git describe" when _not_ on an annotated tag(!): MAJOR.MINOR-REV-HASH.

  # Version to build.
  tag = "4.0";

  # Version info that is built into the binary. Keep in sync with 'tag'. The
  # last 8 digits is a (fake) commit id.
  revision = "4.0-e1aa66cb3f";

in

stdenv.mkDerivation rec {
  name = "ardour-${tag}";

  src = fetchgit {
    url = git://git.ardour.org/ardour/ardour.git;
    rev = "e1aa66cb3f";
    sha256 = "396668fb9116a68f5079f0d880930e890fd0cdf7ee5f3b97fcf44b88cf840b4c";
  };

  buildInputs = 
    [ alsaLib aubio boost cairomm curl doxygen dbus fftw fftwSinglePrec flac glibc
      glibmm graphviz gtk gtkmm jack2 libgnomecanvas libgnomecanvasmm liblo
      libmad libogg librdf librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv-svn lv2
      makeWrapper pango perl pkgconfig python rubberband serd sord-svn sratom suil taglib vampSDK
    ];

  patchPhase = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = \"${revision}\"; }\n' > libs/ardour/revision.cc
    sed 's|/usr/include/libintl.h|${glibc}/include/libintl.h|' -i wscript
    patchShebangs ./tools/
  '';

  configurePhase = "python waf configure --optimize --docs --with-backends=jack,alsa --prefix=$out";

  buildPhase = "python waf";

  installPhase = ''
    python waf install

    # Install desktop file
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/ardour.desktop" << EOF
    [Desktop Entry]
    Name=Ardour 4
    GenericName=Digital Audio Workstation
    Comment=Multitrack harddisk recorder
    Exec=$out/bin/ardour4
    Icon=$out/share/ardour4/icons/ardour_icon_256px.png
    Terminal=false
    Type=Application
    X-MultipleArgs=false
    Categories=GTK;Audio;AudioVideoEditing;AudioVideo;Video;
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Ardour is a digital audio workstation (DAW), You can use it to
      record, edit and mix multi-track audio and midi. Produce your
      own CDs. Mix video soundtracks. Experiment with new ideas about
      music and sound.

      Please consider supporting the ardour project financially:
      https://community.ardour.org/node/8288
    '';
    homepage = http://ardour.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
