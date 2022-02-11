{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
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
, libsndfile
, soxr
, flac
, twolame
, expat
, libid3tag
, libopus
, ffmpeg_4
, soundtouch
, pcre
/*, portaudio - given up fighting their portaudio.patch */
, linuxHeaders
, alsa-lib
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
, wxGTK
, AppKit ? null
, AudioToolbox ? null
, AudioUnit ? null
, Carbon ? null
, Cocoa ? null
, CoreAudio ? null
, CoreAudioKit ? null
, CoreServices ? null
, wxmac
}:

# TODO
# 1. as of 3.0.2, GTK2 is still the recommended version ref https://www.audacityteam.org/download/source/ check if that changes in future versions
# 2. detach sbsms

let
  inherit (lib) optionals;

  wxWidgets_src = fetchFromGitHub {
    owner = "audacity";
    repo = "wxWidgets";
    rev = "07e7d832c7a337aedba3537b90b2c98c4d8e2985";
    sha256 = "1mawnkcrmqj98jp0jxlnh9xkc950ca033ccb51c7035pzmi9if9a";
    fetchSubmodules = true;
  };

  wxGTK' = wxGTK.overrideAttrs (oldAttrs: rec {
    src = wxWidgets_src;
  });

  wxmac' = wxmac.overrideAttrs (oldAttrs: rec {
    src = wxWidgets_src;
  });

in
stdenv.mkDerivation rec {
  pname = "audacity";
  # nixpkgs-update: no auto update
  # Humans too! Let's wait to see how the situation with
  # https://github.com/audacity/audacity/issues/1213 develops before
  # pulling any updates that are subject to this privacy policy. We
  # may wish to switch to a fork, but at the time of writing
  # (2021-07-05) it's too early to tell how well any of the forks will
  # be maintained.
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "audacity";
    repo = "audacity";
    rev = "Audacity-${version}";
    sha256 = "035qq2ff16cdl2cb9iply2bfjmhfl1dpscg79x6c9l0i9m8k41zj";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/audacity/audacity/commit/7f8135e112a0e1e8e906abab9339680d1e491441.patch";
      sha256 = "0zp2iydd46analda9cfnbmzdkjphz5m7dynrdj5qdnmq6j3px9fw";
      name = "audacity_xdg_paths.patch";
    })
    # This is required to make audacity work with nixpkgs’ sqlite
    # https://github.com/audacity/audacity/pull/1802 rebased onto 3.0.2
    ./0001-Use-a-different-approach-to-estimate-the-disk-space-.patch
  ];

  postPatch = ''
    touch src/RevisionIdent.h
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace src/FileNames.cpp \
      --replace /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    python3
  ] ++ optionals stdenv.isLinux [
    linuxHeaders
  ];

  buildInputs = [
    expat
    ffmpeg_4
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
  ] ++ optionals stdenv.isLinux [
    alsa-lib # for portaudio
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
    wxGTK'
    wxGTK'.gtk
  ] ++ optionals stdenv.isDarwin [
    wxmac'
    AppKit
    Cocoa
    CoreAudioKit
    AudioUnit AudioToolbox CoreAudio CoreServices Carbon # for portaudio
  ];

  cmakeFlags = [
    "-Daudacity_use_ffmpeg=linked"
    "-DDISABLE_DYNAMIC_LOADING_FFMPEG=ON"
  ];

  doCheck = false; # Test fails

  meta = with lib; {
    description = "Sound editor with graphical UI";
    homepage = "https://www.audacityteam.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lheckemann veprbl ];
    platforms = platforms.unix;
  };
}
