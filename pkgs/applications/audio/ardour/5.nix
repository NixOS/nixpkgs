{ lib, stdenv
, fetchgit
, alsa-lib
, aubio
, boost
, cairomm
, curl
, doxygen
, fftwSinglePrec
, flac
, glibmm
, graphviz
, gtkmm2
, libjack2
, liblo
, libogg
, libsamplerate
, libsigcxx
, libsndfile
, libusb1
, fluidsynth_1
, hidapi
, libltc
, qm-dsp
, libxml2
, lilv
, lrdf
, lv2
, perl
, pkg-config
, itstool
, python2
, rubberband
, serd
, sord
, sratom
, taglib
, vamp-plugin-sdk
, dbus
, fftw
, pango
, suil
, libarchive
, wafHook
}:
let
  # Ardour git repo uses a mix of annotated and lightweight tags. Annotated
  # tags are used for MAJOR.MINOR versioning, and lightweight tags are used
  # in-between; MAJOR.MINOR.REV where REV is the number of commits since the
  # last annotated tag. A slightly different version string format is needed
  # for the 'revision' info that is built into the binary; it is the format of
  # "git describe" when _not_ on an annotated tag(!): MAJOR.MINOR-REV-HASH.

  # Version to build.
  tag = "5.12";
in stdenv.mkDerivation rec {
  pname = "ardour_5";
  version = "5.12";

  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = "ae0dcdc0c5d13483271065c360e378202d20170a";
    sha256 = "0mla5lm51ryikc2rrk53max2m7a5ds6i1ai921l2h95wrha45nkr";
  };

  nativeBuildInputs = [
    wafHook
    pkg-config
    itstool
    doxygen
    graphviz # for dot
    perl
    python2
  ];

  buildInputs = [
    alsa-lib
    aubio
    boost
    cairomm
    curl
    dbus
    fftw
    fftwSinglePrec
    flac
    glibmm
    gtkmm2
    libjack2
    liblo
    libogg
    libsamplerate
    libsigcxx
    libsndfile
    libusb1
    fluidsynth_1
    hidapi
    libltc
    qm-dsp
    libxml2
    lilv
    lrdf
    lv2
    pango
    rubberband
    serd
    sord
    sratom
    suil
    taglib
    vamp-plugin-sdk
    libarchive
  ];

  wafConfigureFlags = [
    "--optimize"
    "--docs"
    "--use-external-libs"
    "--freedesktop"
    "--with-backends=jack,alsa,dummy"
  ];

  NIX_CFLAGS_COMPILE = "-I${qm-dsp}/include/qm-dsp";

  # ardour's wscript has a "tarball" target but that required the git revision
  # be available. Since this is an unzipped tarball fetched from github we
  # have to do that ourself.
  postPatch = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = \"${tag}-${builtins.substring 0 8 src.rev}\"; }\n' > libs/ardour/revision.cc
    patchShebangs ./tools/
  '';

  postInstall = ''
    # wscript does not install these for some reason
    install -vDm 644 "build/gtk2_ardour/ardour.xml" \
      -t "$out/share/mime/packages"
    install -vDm 644 "build/gtk2_ardour/ardour5.desktop" \
      -t "$out/share/applications"
    for size in 16 22 32 48 256 512; do
      install -vDm 644 "gtk2_ardour/resources/Ardour-icon_''${size}px.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/ardour5.png"
    done
    install -vDm 644 "ardour.1"* -t "$out/share/man/man1"
  '';

  meta = with lib; {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Ardour is a digital audio workstation (DAW), You can use it to
      record, edit and mix multi-track audio and midi. Produce your
      own CDs. Mix video soundtracks. Experiment with new ideas about
      music and sound.

      Please consider supporting the ardour project financially:
      https://community.ardour.org/donate
    '';
    homepage = "https://ardour.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu fps ];
  };
}
