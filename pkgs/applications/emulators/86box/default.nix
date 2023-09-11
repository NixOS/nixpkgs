{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, makeWrapper, freetype, SDL2
, glib, pcre2, openal, rtmidi, fluidsynth, jack2, alsa-lib, qt5, libvncserver
, discord-gamesdk, libpcap, libslirp

, enableDynarec ? with stdenv.hostPlatform; isx86 || isAarch
, enableNewDynarec ? enableDynarec && stdenv.hostPlatform.isAarch
, enableVncRenderer ? false
, unfreeEnableDiscord ? false
}:

stdenv.mkDerivation rec {
  pname = "86Box";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "86Box";
    repo = "86Box";
    rev = "v${version}";
    hash = "sha256-VTfYCVEbArcYVzh3NkX1yBXhtRnGZ/+khk0KG42fs24=";
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
  ] ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optional enableVncRenderer libvncserver;

  cmakeFlags = lib.optional stdenv.isDarwin "-DCMAKE_MACOSX_BUNDLE=OFF"
    ++ lib.optional enableNewDynarec "-DNEW_DYNAREC=ON"
    ++ lib.optional enableVncRenderer "-DVNC=ON"
    ++ lib.optional (!enableDynarec) "-DDYNAREC=OFF"
    ++ lib.optional (!unfreeEnableDiscord) "-DDISCORD=OFF";

  postInstall = lib.optional stdenv.isLinux ''
    install -Dm644 -t $out/share/applications $src/src/unix/assets/net.86box.86Box.desktop

    for size in 48 64 72 96 128 192 256 512; do
      install -Dm644 -t $out/share/icons/hicolor/"$size"x"$size"/apps \
        $src/src/unix/assets/"$size"x"$size"/net.86box.86Box.png
    done;
  '';

  # Some libraries are loaded dynamically, but QLibrary doesn't seem to search
  # the runpath, so use a wrapper instead.
  postFixup = let
    libPath = lib.makeLibraryPath ([
      libpcap
    ] ++ lib.optional unfreeEnableDiscord discord-gamesdk);
    libPathVar = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in
  ''
    wrapProgram $out/bin/86Box \
      "''${qtWrapperArgs[@]}" \
      --prefix ${libPathVar} : "${libPath}"
  '';

  # Do not wrap twice.
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Emulator of x86-based machines based on PCem.";
    homepage = "https://86box.net/";
    license = with licenses; [ gpl2Only ] ++ optional unfreeEnableDiscord unfree;
    maintainers = [ maintainers.jchw ];
    platforms = platforms.linux;
  };
}
