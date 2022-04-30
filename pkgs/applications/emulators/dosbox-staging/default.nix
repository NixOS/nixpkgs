{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_net
, alsa-lib
, copyDesktopItems
, fluidsynth
, gtest
, libGL
, libGLU
, libogg
, libpng
, libslirp
, makeDesktopItem
, makeWrapper
, meson
, libmt32emu
, ninja
, opusfile
, pkg-config
, libpulseaudio
, glib
, libjack2
, libsndfile
}:

stdenv.mkDerivation rec {
  pname = "dosbox-staging";
  version = "0.78.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gozFZcJorZtbEK0joksig6qWmAMy03hmBHiyJMONfpk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_net
    alsa-lib
    fluidsynth
    glib
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
  ];

   NIX_CFLAGS_COMPILE = [
     "-I${SDL2_net}/include/SDL2"
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
    mv $out/bin/dosbox $out/bin/${pname}
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox

    # Create a symlink to dosbox manual instead of merely copying it
    pushd $out/share/man/man1/
    mv dosbox.1.gz ${pname}.1.gz
    ln -s ${pname}.1.gz dosbox.1.gz
    popd
  '';

  meta = with lib; {
    homepage = "https://dosbox-staging.github.io/";
    description = "A modernized DOS emulator";
    longDescription = ''
      DOSBox Staging is an attempt to revitalize DOSBox's development
      process. It's not a rewrite, but a continuation and improvement on the
      existing DOSBox codebase while leveraging modern development tools and
      practices.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ joshuafern AndersonTorres ];
    platforms = platforms.unix;
    priority = 101;
  };
}
# TODO: report upstream about not finding SDL2_net
