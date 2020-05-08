{ stdenv
, fetchgit
, alsaLib
, aubio
, boost
, cairomm
, curl
, doxygen
, fftwSinglePrec
, flac
, glibc
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
, fluidsynth
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
, python3
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
, libpulseaudio
, libuv
, libwebsockets
, cppunit
, readline
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "ardour";
  version = "6.0";

  # don't fetch releases from the GitHub mirror, they are broken
  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = version;
    sha256 = "162jd96zahl05fdmjwvpdfjxbhd6ifbav6xqa0vv6rsdl4zk395q";
  };

  patches = [
    # weird "as" issue: https://tracker.ardour.org/view.php?id=8096
    ./as-flags.patch
  ];

  nativeBuildInputs = [
    wafHook
    pkg-config
    itstool
    doxygen
    graphviz # for dot
    perl
    python3
  ];

  buildInputs = [
    alsaLib
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
    fluidsynth
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
    libpulseaudio
    libuv
    libwebsockets
    cppunit
    readline
  ];

  wafConfigureFlags = [
    "--optimize"
    "--docs"
    "--use-external-libs"
    "--freedesktop"
    "--with-backends=jack,alsa,dummy,pulseaudio"
    "--qm-dsp-include=${qm-dsp}/include/qm-dsp"
  ];

  # Ardour's wscript requires git revision and date to be available.
  # Since they are not, let's generate the file manually.
  postPatch = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "${version}"; const char* date = ""; }\n' > libs/ardour/revision.cc
    patchShebangs ./tools/
  '';

  postInstall = ''
    # wscript does not install these for some reason
    install -vDm 644 "build/gtk2_ardour/ardour.xml" \
      -t "$out/share/mime/packages"
    install -vDm 644 "build/gtk2_ardour/ardour6.desktop" \
      -t "$out/share/applications"
    for size in 16 22 32 48 256 512; do
      install -vDm 644 "gtk2_ardour/resources/Ardour-icon_''${size}px.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/ardour6.png"
    done
    install -vDm 644 "ardour.1"* -t "$out/share/man/man1"
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
    homepage = "https://ardour.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu fps ];
  };
}
