{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, makeWrapper, freetype, SDL2
, glib, pcre2, openal, rtmidi, fluidsynth, jack2, alsa-lib, qt5, libvncserver
<<<<<<< HEAD
, discord-gamesdk, libpcap, libslirp
=======
, discord-gamesdk, libpcap
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

, enableDynarec ? with stdenv.hostPlatform; isx86 || isAarch
, enableNewDynarec ? enableDynarec && stdenv.hostPlatform.isAarch
, enableVncRenderer ? false
, unfreeEnableDiscord ? false
}:

stdenv.mkDerivation rec {
  pname = "86Box";
<<<<<<< HEAD
  version = "4.0";
=======
  version = "3.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "86Box";
    repo = "86Box";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VTfYCVEbArcYVzh3NkX1yBXhtRnGZ/+khk0KG42fs24=";
=======
    hash = "sha256-n3Q/NUiaC6/EZyBUn6jUomnQCqr8tvYKPI5JrRRFScI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    freetype
<<<<<<< HEAD
    fluidsynth
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    SDL2
    glib
    openal
    rtmidi
    pcre2
    jack2
    libpcap
<<<<<<< HEAD
    libslirp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    qt5.qtbase
    qt5.qttools
  ] ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optional enableVncRenderer libvncserver;

  cmakeFlags = lib.optional stdenv.isDarwin "-DCMAKE_MACOSX_BUNDLE=OFF"
    ++ lib.optional enableNewDynarec "-DNEW_DYNAREC=ON"
    ++ lib.optional enableVncRenderer "-DVNC=ON"
    ++ lib.optional (!enableDynarec) "-DDYNAREC=OFF"
    ++ lib.optional (!unfreeEnableDiscord) "-DDISCORD=OFF";

<<<<<<< HEAD
  postInstall = lib.optional stdenv.isLinux ''
    install -Dm644 -t $out/share/applications $src/src/unix/assets/net.86box.86Box.desktop

    for size in 48 64 72 96 128 192 256 512; do
      install -Dm644 -t $out/share/icons/hicolor/"$size"x"$size"/apps \
        $src/src/unix/assets/"$size"x"$size"/net.86box.86Box.png
    done;
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Some libraries are loaded dynamically, but QLibrary doesn't seem to search
  # the runpath, so use a wrapper instead.
  postFixup = let
    libPath = lib.makeLibraryPath ([
      libpcap
<<<<<<< HEAD
=======
      fluidsynth
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
