{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, boost
, chromaprint
, fftw
, gnutls
, libcdio
, libmtp
, libpthreadstubs
, libtasn1
, libXdmcp
, ninja
, pcre
, protobuf
, sqlite
, taglib
, libgpod
, libpulseaudio
, libselinux
, libsepol
, p11-kit
, util-linux
, qtbase
, qtx11extras
, qttools
, withGstreamer ? true
, glib-networking
, gst_all_1
, withVlc ? true
, libvlc
}:

mkDerivation rec {
  pname = "strawberry";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "jonaski";
    repo = pname;
    rev = version;
    hash = "sha256-UjmrU/SA8gf+HwyCb6hm8IClUaEXvWGmIy3xDJPIsgE=";
  };

  # the big strawberry shown in the context menu is *very* much in your face, so use the grey version instead
  postPatch = ''
    substituteInPlace src/context/contextalbum.cpp \
      --replace pictures/strawberry.png pictures/strawberry-grey.png
  '';

  buildInputs = [
    alsa-lib
    boost
    chromaprint
    fftw
    gnutls
    libcdio
    libmtp
    libpthreadstubs
    libtasn1
    libXdmcp
    pcre
    protobuf
    sqlite
    taglib
    qtbase
    qtx11extras
  ] ++ lib.optionals stdenv.isLinux [
    libgpod
    libpulseaudio
    libselinux
    libsepol
    p11-kit
  ] ++ lib.optionals withGstreamer (with gst_all_1; [
    glib-networking
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]) ++ lib.optional withVlc libvlc;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qttools
  ] ++ lib.optionals stdenv.isLinux [
    util-linux
  ];

  postInstall = lib.optionalString withGstreamer ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules"
    )
  '';

  meta = with lib; {
    description = "Music player and music collection organizer";
    homepage = "https://www.strawberrymusicplayer.org/";
    changelog = "https://raw.githubusercontent.com/jonaski/strawberry/${version}/Changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    # upstream says darwin should work but they lack maintainers as of 0.6.6
    platforms = platforms.linux;
  };
}
