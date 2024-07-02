{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
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

  enableDynarec ? with stdenv.hostPlatform; isx86 || isAarch,
  enableNewDynarec ? enableDynarec && stdenv.hostPlatform.isAarch,
  enableVncRenderer ? false,
  unfreeEnableDiscord ? false,
  unfreeEnableRoms ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "PCBox";
  version = "r14275.86b6d80";

  src = fetchFromGitHub {
    owner = "PCBox";
    repo = "PCBox";
    rev = "86b6d807a720daebc8fbaeac34d8c06dabf51dd2";
    hash = "sha256-g5ZvcDGwccHV99BTmSjLTPT/eMyxSM6vOlqggODJXbM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
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
  ] ++ lib.optional stdenv.isLinux alsa-lib ++ lib.optional enableVncRenderer libvncserver;

  cmakeFlags =
    lib.optional stdenv.isDarwin "-DCMAKE_MACOSX_BUNDLE=OFF"
    ++ lib.optional enableNewDynarec "-DNEW_DYNAREC=ON"
    ++ lib.optional enableVncRenderer "-DVNC=ON"
    ++ lib.optional (!enableDynarec) "-DDYNAREC=OFF"
    ++ lib.optional (!unfreeEnableDiscord) "-DDISCORD=OFF";

  postInstall =
    lib.optionalString stdenv.isLinux ''
      install -Dm644 $src/src/unix/assets/net.86box.86Box.desktop $out/share/applications/net.pcbox.PCBox.desktop
      sed -i 's#Name=86Box#Name=PCBox#g' $out/share/applications/net.pcbox.PCBox.desktop
      sed -i 's#Exec=86Box#Exec=PCBox -P .local/share/PCBox#g' $out/share/applications/net.pcbox.PCBox.desktop

      for size in 48 64 72 96 128 192 256 512; do
        install -Dm644 -t $out/share/icons/hicolor/"$size"x"$size"/apps \
          $src/src/unix/assets/"$size"x"$size"/net.86box.86Box.png
      done;
    ''
    + lib.optionalString unfreeEnableRoms ''
      mkdir -p $out/share/PCBox
      ln -s ${finalAttrs.passthru.roms} $out/share/PCBox/roms
    '';

  passthru = {
    roms = fetchFromGitHub {
      owner = "PCBox";
      repo = "roms";
      rev = "d2f9f57838f86e104d021b8acdb06aa8ce0fc222";
      hash = "sha256-3plxCWNdmH2Q+oqTEpRzxBug1uUQNEAtEpR9fhko5N4=";
    };
  };

  # Some libraries are loaded dynamically, but QLibrary doesn't seem to search
  # the runpath, so use a wrapper instead.
  preFixup =
    let
      libPath = lib.makeLibraryPath ([ libpcap ] ++ lib.optional unfreeEnableDiscord discord-gamesdk);
      libPathVar = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      makeWrapperArgs+=(--prefix ${libPathVar} : "${libPath}")
    '';

  meta = with lib; {
    description = "Emulator of x86-based machines forked from 86Box.";
    mainProgram = "PCBox";
    homepage = "https://pcbox-emu.xyz/";
    license = with licenses; [ gpl2Only ] ++ optional (unfreeEnableDiscord || unfreeEnableRoms) unfree;
    maintainers = [ maintainers.syboxez ];
    platforms = platforms.linux;
  };
})
