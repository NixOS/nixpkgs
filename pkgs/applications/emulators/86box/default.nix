{
  stdenv,
  apple-sdk_11,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  makeWrapper,
  freetype,
  SDL2,
  glib,
  pcre2,
  openal,
  rtmidi,
  fluidsynth,
  jack2,
  alsa-lib,
  qt5,
  libvncserver,
  discord-gamesdk,
  libpcap,
  libslirp,
  wayland,
  wayland-scanner,
  libsndfile,
  flac,
  libogg,
  libvorbis,
  libopus,
  libmpg123,

  enableDynarec ? with stdenv.hostPlatform; isx86 || isAarch,
  enableNewDynarec ? enableDynarec && stdenv.hostPlatform.isAarch,
  enableVncRenderer ? false,
  enableWayland ? stdenv.hostPlatform.isLinux,
  unfreeEnableDiscord ? false,
  unfreeEnableRoms ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "86Box";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "86Box";
    repo = "86Box";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ue5Coy2MpP7Iwl81KJPQPC7eD53/Db5a0PGIR+DdPYI=";
  };

  patches = [ ./darwin.patch ];

  postPatch = ''
    substituteAllInPlace src/qt/qt_platform.cpp
  '';

  nativeBuildInputs =
    [
      cmake
      pkg-config
      makeWrapper
      qt5.wrapQtAppsHook
    ]
    ++ lib.optionals enableWayland [
      extra-cmake-modules
      wayland-scanner
    ];

  buildInputs =
    [
      freetype
      fluidsynth
      SDL2
      glib
      openal
      rtmidi
      pcre2
      jack2
      libpcap
      libslirp
      qt5.qtbase
      qt5.qttools
      libsndfile
      flac.dev
      libogg.dev
      libvorbis.dev
      libopus.dev
      libmpg123.dev
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableVncRenderer libvncserver
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  cmakeFlags =
    lib.optional stdenv.hostPlatform.isDarwin "-DCMAKE_MACOSX_BUNDLE=OFF"
    ++ lib.optional enableNewDynarec "-DNEW_DYNAREC=ON"
    ++ lib.optional enableVncRenderer "-DVNC=ON"
    ++ lib.optional (!enableDynarec) "-DDYNAREC=OFF"
    ++ lib.optional (!unfreeEnableDiscord) "-DDISCORD=OFF";

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 -t $out/share/applications $src/src/unix/assets/net.86box.86Box.desktop

      for size in 48 64 72 96 128 192 256 512; do
        install -Dm644 -t $out/share/icons/hicolor/"$size"x"$size"/apps \
          $src/src/unix/assets/"$size"x"$size"/net.86box.86Box.png
      done;
    ''
    + lib.optionalString unfreeEnableRoms ''
      mkdir -p $out/share/86Box
      ln -s ${finalAttrs.passthru.roms} $out/share/86Box/roms
    '';

  passthru = {
    roms = fetchFromGitHub {
      owner = "86Box";
      repo = "roms";
      rev = "v${finalAttrs.version}";
      hash = "sha256-p3djn950mTUIchFCEg56JbJtIsUuxmqRdYFRl50kI5Y=";
    };
    updateScript = ./update.sh;
  };

  # Some libraries are loaded dynamically, but QLibrary doesn't seem to search
  # the runpath, so use a wrapper instead.
  preFixup =
    let
      libPath = lib.makeLibraryPath ([ libpcap ] ++ lib.optional unfreeEnableDiscord discord-gamesdk);
      libPathVar = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      makeWrapperArgs+=(--prefix ${libPathVar} : "${libPath}")
    '';

  meta = {
    description = "Emulator of x86-based machines based on PCem";
    mainProgram = "86Box";
    homepage = "https://86box.net/";
    changelog = "https://github.com/86Box/86Box/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      [ gpl2Only ] ++ lib.optional (unfreeEnableDiscord || unfreeEnableRoms) unfree;
    maintainers = with lib.maintainers; [
      jchw
      matteopacini
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
