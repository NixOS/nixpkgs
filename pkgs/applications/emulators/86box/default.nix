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
  pname = "86Box";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "86Box";
    repo = "86Box";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ioE0EVIXv/biXXvLqwhmtZ/RJM0nLqcE+i+CU+WXBY4=";
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
      hash = "sha256-58nNTOLund/KeDlNwzwwihjFVigs/P0K8SN07zExE2c=";
    };
    updateScript = ./update.sh;
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
    description = "Emulator of x86-based machines based on PCem";
    mainProgram = "86Box";
    homepage = "https://86box.net/";
    license = with licenses; [ gpl2Only ] ++ optional (unfreeEnableDiscord || unfreeEnableRoms) unfree;
    maintainers = [ maintainers.jchw ];
    platforms = platforms.linux;
  };
})
