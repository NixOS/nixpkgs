{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, doxygen
, fftwSinglePrec, flac, glibc, glibmm, graphviz, gtkmm2, libjack2
, libgnomecanvas, libgnomecanvasmm, liblo, libmad, libogg, librdf
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lv2, makeWrapper
, perl, pkgconfig, python2, rubberband, serd, sord, sratom
, taglib, vampSDK, dbus, fftw, pango, suil, libarchive
, wafHook }:

let

  # Ardour git repo uses a mix of annotated and lightweight tags. Annotated
  # tags are used for MAJOR.MINOR versioning, and lightweight tags are used
  # in-between; MAJOR.MINOR.REV where REV is the number of commits since the
  # last annotated tag. A slightly different version string format is needed
  # for the 'revision' info that is built into the binary; it is the format of
  # "git describe" when _not_ on an annotated tag(!): MAJOR.MINOR-REV-HASH.

  # Version to build.
  tag = "5.12";

in

stdenv.mkDerivation rec {
  name = "ardour-${tag}";

  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = "ae0dcdc0c5d13483271065c360e378202d20170a";
    sha256 = "0mla5lm51ryikc2rrk53max2m7a5ds6i1ai921l2h95wrha45nkr";
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs =
    [ alsaLib aubio boost cairomm curl doxygen dbus fftw fftwSinglePrec flac
      glibmm graphviz gtkmm2 libjack2 libgnomecanvas libgnomecanvasmm liblo
      libmad libogg librdf librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lv2
      makeWrapper pango perl pkgconfig python2 rubberband serd sord
      sratom suil taglib vampSDK libarchive
    ];

  # ardour's wscript has a "tarball" target but that required the git revision
  # be available. Since this is an unzipped tarball fetched from github we
  # have to do that ourself.
  patchPhase = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = \"${tag}-${builtins.substring 0 8 src.rev}\"; }\n' > libs/ardour/revision.cc
    sed 's|/usr/include/libintl.h|${glibc.dev}/include/libintl.h|' -i wscript
    patchShebangs ./tools/
  '';

  configureFlags = [
    "--optimize"
    "--docs"
    "--with-backends=jack,alsa,dummy"
  ];

  postInstall = ''
    # Install desktop file
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/ardour.desktop" << EOF
    [Desktop Entry]
    Name=Ardour 5
    GenericName=Digital Audio Workstation
    Comment=Multitrack harddisk recorder
    Exec=$out/bin/ardour5
    Icon=$out/share/ardour5/resources/Ardour-icon_256px.png
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
    maintainers = [ maintainers.goibhniu maintainers.fps ];
  };
}
