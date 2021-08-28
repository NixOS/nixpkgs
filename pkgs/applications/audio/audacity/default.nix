{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, wxGTK
, pkg-config
, python3
, gettext
, file
, libvorbis
, libmad
, libjack2
, lv2
, lilv
, serd
, sord
, sqlite
, sratom
, suil
, alsaLib
, libsndfile
, soxr
, flac
, twolame
, expat
, libid3tag
, libopus
, ffmpeg
, soundtouch
, pcre /*, portaudio - given up fighting their portaudio.patch */
, linuxHeaders
, at-spi2-core
, dbus
, epoxy
, libXdmcp
, libXtst
, libpthreadstubs
, libselinux
, libsepol
, libxkbcommon
, util-linux
}:

# TODO
# 1. as of 3.0.2, GTK2 is still the recommended version ref https://www.audacityteam.org/download/source/ check if that changes in future versions
# 2. detach sbsms

let
  inherit (lib) optionals;

  wxGTK' = wxGTK.overrideAttrs (oldAttrs: rec {
    src = fetchFromGitHub {
      owner = "audacity";
      repo = "wxWidgets";
      rev = "07e7d832c7a337aedba3537b90b2c98c4d8e2985";
      sha256 = "1mawnkcrmqj98jp0jxlnh9xkc950ca033ccb51c7035pzmi9if9a";
      fetchSubmodules = true;
    };
  });

in
stdenv.mkDerivation rec {
  pname = "audacity";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "audacity";
    repo = "audacity";
    rev = "Audacity-${version}";
    sha256 = "035qq2ff16cdl2cb9iply2bfjmhfl1dpscg79x6c9l0i9m8k41zj";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/audacity/audacity/pull/831/commits/007852e51fcbb5f1f359d112f28b8984a604dac6.patch";
      sha256 = "0zp2iydd46analda9cfnbmzdkjphz5m7dynrdj5qdnmq6j3px9fw";
      name = "audacity_xdg_paths.patch";
    })
  ];

  postPatch = ''
    touch src/RevisionIdent.h

    substituteInPlace src/FileNames.cpp \
      --replace /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '';

  # audacity only looks for ffmpeg at runtime, so we need to link it in manually
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
    pkg-config
    python3
  ] ++ optionals stdenv.isLinux [
    linuxHeaders
  ];

  buildInputs = [
    alsaLib
    expat
    ffmpeg
    file
    flac
    libid3tag
    libjack2
    libmad
    libopus
    libsndfile
    libvorbis
    lilv
    lv2
    pcre
    serd
    sord
    soundtouch
    soxr
    sqlite
    sratom
    suil
    twolame
    wxGTK'
    wxGTK'.gtk
  ] ++ optionals stdenv.isLinux [
    at-spi2-core
    dbus
    epoxy
    libXdmcp
    libXtst
    libpthreadstubs
    libxkbcommon
    libselinux
    libsepol
    util-linux
  ];

  doCheck = false; # Test fails

  meta = with lib; {
    description = "Sound editor with graphical UI";
    homepage = "https://www.audacityteam.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lheckemann ];
    platforms = platforms.linux;
  };
}
