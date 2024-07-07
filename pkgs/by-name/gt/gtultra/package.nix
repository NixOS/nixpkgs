{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  alsa-lib,
  copyDesktopItems,
  imagemagick,
  makeDesktopItem,
  pkg-config,
  SDL2,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtultra";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "jpage8580";
    repo = "GTUltra";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-hewj7qrPx4V6lSjbiCIB8yTAmfXxm5HEzB+wftkPt4E=";
  };

  patches = [
    # https://github.com/jpage8580/GTUltra/pull/22
    ./fix-format.patch
    # https://github.com/jpage8580/GTUltra/pull/73
    ./fix-buffer-overflow.patch

    # Fix missing inclusion of Darwin target conditionals
    (fetchpatch {
      url = "https://github.com/thestk/rtmidi/commit/9d863beb28f03ec53f3e4c22cc0d3c34a1e1789b.patch";
      stripLen = 1;
      extraPrefix = "src/";
      hash = "sha256-t3xCJxZk2Rk0XDZ4s8Yt8KOHsUNfeucr0aF+xmIW8OY=";
    })
  ];

  postPatch = ''
    # remove prebuilts
    rm linux/* mac/* win32/*
    rm -r src/datafiles

    # Remove unconditional stripping
    substituteInPlace src/makefile.common \
      --replace-fail 'strip $@' '#strip $@'

    substituteInPlace src/makefile.mac \
      --replace-fail "\`sdl2-config --cflags'" '`sdl2-config --cflags`'
  '';

  nativeBuildInputs = [
    imagemagick
    copyDesktopItems
    pkg-config
  ];

  buildInputs =
    [ SDL2 ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreAudio
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreMIDI
    ];

  # Uses sdl2-config
  strictDeps = false;

  makefile = "makefile${lib.optionalString stdenv.hostPlatform.isDarwin ".mac"}";

  makeFlags = [ "-Csrc" ];

  desktopItems = [
    (makeDesktopItem {
      name = "gtultra";
      desktopName = "GTUltra";
      genericName = "Music Tracker";
      exec = "gtultra";
      icon = "gtultra";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
      ];
      keywords = [
        "tracker"
        "music"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ${
      if stdenv.hostPlatform.isDarwin then "mac" else "linux"
    }/{gtultra,mod2sng2,ss2stereo} -t $out/bin
    convert src/goattrk2.bmp gtultra.png
    install -Dm644 gtultra.png $out/share/icons/hicolor/32x32/apps/gtultra.png
    install -Dm644 GTUltra.pdf $out/share/doc/gtultra/GTUltra.pdf

    runHook postInstall
  '';

  meta = {
    description = "Extensively modified GoatTracker Stereo with many new features";
    homepage = "https://github.com/jpage8580/GTUltra";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "gtultra";
    platforms = lib.platforms.all;
  };
})
