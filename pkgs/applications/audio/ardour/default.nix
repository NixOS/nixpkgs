{ lib
, stdenv
, fetchgit
, fetchzip
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
, fluidsynth
, glibc
, glibmm
, graphviz
, gtkmm2
, harvid
, hidapi
, itstool
, kissfft
, libarchive
, libjack2
, liblo
, libltc
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
, qm-dsp
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
, optimize ? true # disable to print Lua DSP script output to stdout
, videoSupport ? true
}:
stdenv.mkDerivation rec {
  pname = "ardour";
  version = "8.6";

  # We can't use `fetchFromGitea` here, as attempting to fetch release archives from git.ardour.org
  # result in an empty archive. See https://tracker.ardour.org/view.php?id=7328 for more info.
  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = version;
    hash = "sha256-sMp24tjtX8fZJWc7dvb+9e6pEflT4ugoOZjDis6/3nM=";
  };

  bundledContent = fetchzip {
    url = "https://web.archive.org/web/20221026200824/http://stuff.ardour.org/loops/ArdourBundledMedia.zip";
    hash = "sha256-IbPQWFeyMuvCoghFl1ZwZNNcSvLNsH84rGArXnw+t7A=";
    # archive does not contain a single folder at the root
    stripRoot = false;
  };

  patches = [
    # AS=as in the environment causes build failure https://tracker.ardour.org/view.php?id=8096
    ./as-flags.patch
    ./default-plugin-search-paths.patch
  ];

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
    fluidsynth
    glibmm
    gtkmm2
    hidapi
    itstool
    kissfft
    libarchive
    libjack2
    liblo
    libltc
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
    qm-dsp
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
    "--ptformat"
    "--run-tests"
    "--test"
    # since we don't have https://github.com/agfline/LibAAF yet,
    # we need to use some of ardours internal libs, see:
    # https://discourse.ardour.org/t/ardour-8-2-released/109615/6
    # and
    # https://discourse.ardour.org/t/ardour-8-2-released/109615/8
    # "--use-external-libs"
  ] ++ lib.optional optimize "--optimize";

  postInstall = ''
    # wscript does not install these for some reason
    install -vDm 644 "build/gtk2_ardour/ardour.xml" \
      -t "$out/share/mime/packages"
    install -vDm 644 "build/gtk2_ardour/ardour${lib.versions.major version}.desktop" \
      -t "$out/share/applications"
    for size in 16 22 32 48 256 512; do
      install -vDm 644 "gtk2_ardour/resources/Ardour-icon_''${size}px.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/ardour${lib.versions.major version}.png"
    done
    install -vDm 644 "ardour.1"* -t "$out/share/man/man1"

    # install additional bundled beats, chords and progressions
    cp -rp "${bundledContent}"/* "$out/share/ardour${lib.versions.major version}/media"
  '' + lib.optionalString videoSupport ''
    # `harvid` and `xjadeo` must be accessible in `PATH` for video to work.
    wrapProgram "$out/bin/ardour${lib.versions.major version}" \
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
    mainProgram = "ardour8";
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon mitchmindtree ];
  };
}
