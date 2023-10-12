{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, wrapGAppsHook
, pkg-config
, python3
, gettext
, file
, libvorbis
, libmad
, libjack2
, lv2
, lilv
, mpg123
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
, wavpack
, wxGTK32
, gtk3
, libpng
, libjpeg
, AppKit
, CoreAudioKit
}:

# TODO
# 1. detach sbsms

stdenv.mkDerivation rec {
  pname = "audacity";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Audacity-${version}";
    hash = "sha256-m38Awdv2ew+MKqd68x/ZsRBwidM2KJ3BRykIKgnFSx4=";
  };

  postPatch = ''
    mkdir src/private
    substituteInPlace scripts/build/macOS/fix_bundle.py \
      --replace "path.startswith('/usr/lib/')" "path.startswith('${builtins.storeDir}')"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace libraries/lib-files/FileNames.cpp \
      --replace /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '' + lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.targetPlatform.darwinMinVersion "11.0") ''
    sed -z -i "s/NSAppearanceName.*systemAppearance//" src/AudacityApp.mm
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    python3
    makeWrapper
    wrapGAppsHook
  ] ++ lib.optionals stdenv.isLinux [
    linuxHeaders
  ];

  buildInputs = [
    expat
    ffmpeg_4
    file
    flac
    gtk3
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
    mpg123
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
    wavpack
    wxGTK32
  ] ++ lib.optionals stdenv.isLinux [
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
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    CoreAudioKit # for portaudio
    libpng
    libjpeg
  ];

  cmakeFlags = [
    "-DAUDACITY_BUILD_LEVEL=2"
    "-DAUDACITY_REV_LONG=nixpkgs"
    "-DAUDACITY_REV_TIME=nixpkgs"
    "-DDISABLE_DYNAMIC_LOADING_FFMPEG=ON"
    "-Daudacity_conan_enabled=Off"
    "-Daudacity_use_ffmpeg=loaded"
    "-Daudacity_has_vst3=Off"
    "-Daudacity_has_crashreports=Off"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # Fix duplicate store paths
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  # [ 57%] Generating LightThemeAsCeeCode.h...
  # ../../utils/image-compiler: error while loading shared libraries:
  # lib-theme.so: cannot open shared object file: No such file or directory
  preBuild = ''
    export LD_LIBRARY_PATH=$PWD/Release/lib/audacity
  '';

  doCheck = false; # Test fails

  # Replace audacity's wrapper, to:
  # - put it in the right place, it shouldn't be in "$out/audacity"
  # - Add the ffmpeg dynamic dependency
  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram "$out/bin/audacity" \
      --prefix LD_LIBRARY_PATH : "$out/lib/audacity":${lib.makeLibraryPath [ ffmpeg_4 ]} \
      --suffix AUDACITY_MODULES_PATH : "$out/lib/audacity/modules" \
      --suffix AUDACITY_PATH : "$out/share/audacity"
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Audacity.app $out/Applications/
    makeWrapper $out/Applications/Audacity.app/Contents/MacOS/Audacity $out/bin/audacity
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
    maintainers = with maintainers; [ lheckemann veprbl wegank ];
    platforms = platforms.unix;
  };
}
