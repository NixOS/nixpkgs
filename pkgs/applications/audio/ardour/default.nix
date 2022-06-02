{ lib, stdenv
, fetchgit
, alsa-lib
, aubio
, boost
, cairomm
, cppunit
, curl
, dbus
, doxygen
, ffmpeg
, fftw
, fftwSinglePrec
, flac
, glibc
, glibmm
, graphviz
, gtkmm2
, harvid
, itstool
, libarchive
, libjack2
, liblo
, libogg
, libpulseaudio
, librdf_raptor
, librdf_rasqal
, libsamplerate
, libsigcxx
, libsndfile
, libusb1
, libuv
, libwebsockets
, libxml2
, libxslt
, lilv
, lrdf
, lv2
, makeWrapper
, pango
, perl
, pkg-config
, python3
, readline
, rubberband
, serd
, sord
, soundtouch
, sratom
, suil
, taglib
, vamp-plugin-sdk
, wafHook
, xjadeo
, videoSupport ? true
}:
stdenv.mkDerivation rec {
  pname = "ardour";
  version = "6.9";

  # don't fetch releases from the GitHub mirror, they are broken
  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = version;
    sha256 = "0vlcbd70y0an881zv87kc3akmaiz4w7whsy3yaiiqqjww35jg1mm";
  };

  patches = [
    # AS=as in the environment causes build failure https://tracker.ardour.org/view.php?id=8096
    ./as-flags.patch
  ];

  nativeBuildInputs = [
    doxygen
    graphviz # for dot
    itstool
    makeWrapper
    perl
    pkg-config
    python3
    wafHook
  ];

  buildInputs = [
    alsa-lib
    aubio
    boost
    cairomm
    cppunit
    curl
    dbus
    ffmpeg
    fftw
    fftwSinglePrec
    flac
    glibmm
    gtkmm2
    itstool
    libarchive
    libjack2
    liblo
    libogg
    libpulseaudio
    librdf_raptor
    librdf_rasqal
    libsamplerate
    libsigcxx
    libsndfile
    libusb1
    libuv
    libwebsockets
    libxml2
    libxslt
    lilv
    lrdf
    lv2
    pango
    perl
    python3
    readline
    rubberband
    serd
    sord
    soundtouch
    sratom
    suil
    taglib
    vamp-plugin-sdk
  ] ++ lib.optionals videoSupport [ harvid xjadeo ];

  wafConfigureFlags = [
    "--cxx11"
    "--docs"
    "--freedesktop"
    "--no-phone-home"
    "--optimize"
    "--ptformat"
    "--run-tests"
    "--test"
  ];
  # removed because it fixes https://tracker.ardour.org/view.php?id=8161 and https://tracker.ardour.org/view.php?id=8437
  # "--use-external-libs"

  # Ardour's wscript requires git revision and date to be available.
  # Since they are not, let's generate the file manually.
  postPatch = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "${version}"; const char* date = ""; }\n' > libs/ardour/revision.cc
    sed 's|/usr/include/libintl.h|${glibc.dev}/include/libintl.h|' -i wscript
    patchShebangs ./tools/
    substituteInPlace libs/ardour/video_tools_paths.cc \
      --replace 'ffmpeg_exe = X_("");' 'ffmpeg_exe = X_("${ffmpeg}/bin/ffmpeg");' \
      --replace 'ffprobe_exe = X_("");' 'ffprobe_exe = X_("${ffmpeg}/bin/ffprobe");'
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
  '' + lib.optionalString videoSupport ''
    # `harvid` and `xjadeo` must be accessible in `PATH` for video to work.
    wrapProgram "$out/bin/ardour6" \
      --prefix PATH : "${lib.makeBinPath [ harvid xjadeo ]}"
  '';

  LINKFLAGS = "-lpthread";

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
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu magnetophon mitchmindtree ];
  };
}
