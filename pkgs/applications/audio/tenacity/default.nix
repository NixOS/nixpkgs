{ stdenv
, lib
, fetchFromSourcehut
, cmake
, wxGTK
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
  version = "unstable-2021-10-18";

  src = fetchFromSourcehut {
    owner = "~tenacity";
    repo = "tenacity";
    rev = "697c0e764ccb19c1e2f3073ae08ecdac7aa710e4";
    sha256 = "1fc9xz8lyl8si08wkzncpxq92vizan60c3640qr4kbnxg7vi2iy4";
  };

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

  NIX_CFLAGS_COMPILE = "-D GIT_DESCRIBE=\"\"";

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
    wxGTK
    wxGTK.gtk
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
