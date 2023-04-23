{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, SDL2
, SDL2_image
, SDL2_net
, alsa-lib
, copyDesktopItems
, fluidsynth
, glib
, gtest
, iir1
, libGL
, libGLU
, libjack2
, libmt32emu
, libogg
, libpng
, libpulseaudio
, libslirp
, libsndfile
, makeDesktopItem
, makeWrapper
, meson
, ninja
, opusfile
, pkg-config
, speexdsp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosbox-staging";
  version = "0.80.1";

  src = fetchFromGitHub {
    owner = "dosbox-staging";
    repo = "dosbox-staging";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I90poBeLSq1c8PXyjrx7/UcbfqFNnnNiXfJdWhLPGMc=";
  };

  patches = [
    # Pull missind SDL2_net dependency:
    #   https://github.com/dosbox-staging/dosbox-staging/pull/2358
    (fetchpatch {
      name = "sdl2-net.patch";
      url = "https://github.com/dosbox-staging/dosbox-staging/commit/1b02f187a39263f4b0285323dcfe184bccd749c2.patch";
      hash = "sha256-Ev97xApInu6r5wvI9Q7FhkSXqtMW/rwJj48fExvqnT0=";
    })

    # Pull missing SDL2_image dependency:
    #   https://github.com/dosbox-staging/dosbox-staging/pull/2239
    (fetchpatch {
      name = "sdl2-image.patch";
      url = "https://github.com/dosbox-staging/dosbox-staging/commit/ca8b7a906d29a3f8ce956c4af7dc829a6ac3e229.patch";
      hash = "sha256-WtTVSWWSlfXrdPVsnlDe4P5K/Fnj4QsOzx3Wo/Kusmg=";
      includes = [ "src/gui/meson.build" ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    glib
    iir1
    libGL
    libGLU
    libjack2
    libmt32emu
    libogg
    libpng
    libpulseaudio
    libslirp
    libsndfile
    opusfile
    SDL2
    SDL2_image
    SDL2_net
    speexdsp
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dosbox-staging";
      exec = "dosbox-staging";
      icon = "dosbox-staging";
      comment = "x86 dos emulator enhanced";
      desktopName = "DosBox-Staging";
      genericName = "DOS emulator";
      categories = [ "Emulator" "Game" ];
    })
  ];

  postFixup = ''
    # Rename binary, add a wrapper, and copy manual to avoid conflict with
    # original dosbox. Doing it this way allows us to work with frontends and
    # launchers that expect the binary to be named dosbox, but get out of the
    # way of vanilla dosbox if the user desires to install that as well.
    mv $out/bin/dosbox $out/bin/dosbox-staging
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox

    # Create a symlink to dosbox manual instead of copying it
    pushd $out/share/man/man1/
    ln -s dosbox.1.gz dosbox-staging.1.gz
    popd
  '';

  meta = {
    homepage = "https://dosbox-staging.github.io/";
    description = "A modernized DOS emulator";
    longDescription = ''
      DOSBox Staging is an attempt to revitalize DOSBox's development
      process. It's not a rewrite, but a continuation and improvement on the
      existing DOSBox codebase while leveraging modern development tools and
      practices.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ joshuafern AndersonTorres ];
    platforms = lib.platforms.unix;
    priority = 101;
  };
})
# TODO: report upstream about not finding SDL2_net
