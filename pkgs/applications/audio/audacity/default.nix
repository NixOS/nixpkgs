{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
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
, lame
, twolame
, expat
, libid3tag
, libopus
, libuuid
, ffmpeg_4
, soundtouch
, pcre
, portaudio # given up fighting their portaudio.patch?
, portmidi
, linuxHeaders
, alsa-lib
, at-spi2-core
, dbus
, libepoxy
, libXdmcp
, libXtst
, libpthreadstubs
, libsbsms_2_3_0
, libselinux
, libsepol
, libxkbcommon
, util-linux
, wxGTK
, libpng
, libjpeg
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
  pname = "audacity";
  version = "3.1.3";

  wxWidgets_src = fetchFromGitHub {
    owner = pname;
    repo = "wxWidgets";
    rev = "v${version}-${pname}";
    sha256 = "sha256-KrmYYv23DHBYKIuxMYBioCQ2e4KWdgmuREnimtm0XNU=";
    fetchSubmodules = true;
  };

  wxGTK' = wxGTK.overrideAttrs (oldAttrs: rec {
    src = wxWidgets_src;
  });

  wxmac' = wxmac.overrideAttrs (oldAttrs: rec {
    src = wxWidgets_src;
  });
in stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Audacity-${version}";
    sha256 = "sha256-sdI4paxIHDZgoWTCekjrkFR4JFpQC6OatcnJdVXCCZk=";
  };

  postPatch = ''
    mkdir src/private
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace libraries/lib-files/FileNames.cpp \
      --replace /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    python3
  ] ++ optionals stdenv.isLinux [
    linuxHeaders
    makeWrapper
  ];

  buildInputs = [
    expat
    ffmpeg_4
    file
    flac
    lame
    libid3tag
    libjack2
    libmad
    libopus
    libsbsms_2_3_0
    libsndfile
    libvorbis
    lilv
    lv2
    pcre
    portmidi
    serd
    sord
    soundtouch
    soxr
    sqlite
    sratom
    suil
    twolame
    portaudio
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
    libuuid
    util-linux
    wxGTK'
    wxGTK'.gtk
  ] ++ optionals stdenv.isDarwin [
    wxmac'
    AppKit
    Cocoa
    CoreAudioKit
    AudioUnit AudioToolbox CoreAudio CoreServices Carbon # for portaudio
    libpng
    libjpeg
  ];

  cmakeFlags = [
    "-DAUDACITY_REV_LONG=nixpkgs"
    "-DAUDACITY_REV_TIME=nixpkgs"
    "-DDISABLE_DYNAMIC_LOADING_FFMPEG=ON"
    "-Daudacity_conan_enabled=Off"
    "-Daudacity_use_ffmpeg=loaded"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doCheck = false; # Test fails

  # Replace audacity's wrapper, to:
  # - put it in the right place, it shouldn't be in "$out/audacity"
  # - Add the ffmpeg dynamic dependency
  postInstall = lib.optionalString stdenv.isLinux ''
    rm "$out/audacity"
    wrapProgram "$out/bin/audacity" \
      --prefix LD_LIBRARY_PATH : "$out/lib/audacity":${lib.makeLibraryPath [ ffmpeg_4 ]} \
      --suffix AUDACITY_MODULES_PATH : "$out/lib/audacity/modules" \
      --suffix AUDACITY_PATH : "$out/share/audacity"
  '';

  meta = with lib; {
    description = "Sound editor with graphical UI";
    homepage = "https://www.audacityteam.org";
    changelog = "https://github.com/audacity/audacity/releases";
    license = with licenses; [
      gpl2Plus
      # Must be GPL3 when building with "technologies that require it,
      # such as the VST3 audio plugin interface".
      # https://github.com/audacity/audacity/discussions/2142.
      gpl3
      # Documentation.
      cc-by-30
    ];
    maintainers = with maintainers; [ lheckemann veprbl ];
    platforms = platforms.unix;
    # darwin-aarch due to qtbase broken for it.
    # darwin-x86_64 due to
    # https://logs.nix.ci/?attempt_id=5cbc4581-09b4-4148-82fe-0326411a56b3&key=nixos%2Fnixpkgs.152273.
    broken = stdenv.isDarwin;
  };
}
