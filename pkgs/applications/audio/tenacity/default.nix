{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, wxGTK32
, gtk3
, pkg-config
, python3
, gettext
, glib
, file
, lame
, libvorbis
, libmad
, libjack2
, lv2
, lilv
, makeWrapper
, serd
, sord
, sqlite
, sratom
, suil
, alsa-lib
, libsndfile
, soxr
, flac
, twolame
, expat
, libid3tag
, libopus
, ffmpeg
, soundtouch
, pcre
, portaudio
, linuxHeaders
, at-spi2-core
, dbus
, libepoxy
, libXdmcp
, libXtst
, libpthreadstubs
, libselinux
, libsepol
, libxkbcommon
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "tenacity";
  version = "unstable-2022-06-30";

  src = fetchFromGitHub {
    owner = "tenacityteam";
    repo = pname;
    rev = "91f8b4340b159af551fff94a284c6b0f704a7932";
    sha256 = "sha256-4VWckXzqo2xspw9eUloDvjxQYbsHn6ghEDw+hYqJcCE=";
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/wxwidgets-gtk3-3.1.6-plus.patch?h=tenacity-wxgtk3-git&id=c2503538fa7d7001181905988179952d09f69659";
      postFetch = "echo >> $out";
      sha256 = "sha256-xRY1tizBJ9CBY6e9oZVz4CWx7DWPGD9A9Ysol4prBww=";
    })
  ];

  postPatch = ''
    touch src/RevisionIdent.h

    substituteInPlace src/FileNames.cpp \
      --replace /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '';

  postFixup = ''
    rm $out/tenacity
    wrapProgram "$out/bin/tenacity" \
      --suffix AUDACITY_PATH : "$out/share/tenacity" \
      --suffix AUDACITY_MODULES_PATH : "$out/lib/tenacity/modules" \
      --prefix LD_LIBRARY_PATH : "$out/lib/tenacity" \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  env.NIX_CFLAGS_COMPILE = "-D GIT_DESCRIBE=\"\"";

  # tenacity only looks for ffmpeg at runtime, so we need to link it in manually
  NIX_LDFLAGS = toString [
    "-lavcodec"
    "-lavdevice"
    "-lavfilter"
    "-lavformat"
    "-lavresample"
    "-lavutil"
    "-lpostproc"
    "-lswresample"
    "-lswscale"
  ];

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isLinux [
    linuxHeaders
  ];

  buildInputs = [
    alsa-lib
    expat
    ffmpeg
    file
    flac
    glib
    lame
    libid3tag
    libjack2
    libmad
    libopus
    libsndfile
    libvorbis
    lilv
    lv2
    pcre
    portaudio
    serd
    sord
    soundtouch
    soxr
    sqlite
    sratom
    suil
    twolame
    wxGTK32
    gtk3
  ] ++ lib.optionals stdenv.isLinux [
    at-spi2-core
    dbus
    libepoxy
    libXdmcp
    libXtst
    libpthreadstubs
    libxkbcommon
    libselinux
    libsepol
    util-linux
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta = with lib; {
    description = "Sound editor with graphical UI";
    homepage = "https://tenacityaudio.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ irenes lheckemann ];
    platforms = platforms.linux;
  };
}
