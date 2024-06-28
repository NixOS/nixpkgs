{ lib
, rustPlatform
, fetchFromGitHub
, cli ? false
, pkg-config
, glib
, alsa-lib
, atkmm
, gtk3
, wrapGAppsHook
, ffmpeg-full
, vulkan-loader
, makeWrapper
, fontconfig
, libxkbcommon
}:

rustPlatform.buildRustPackage rec {
  pname = "neothesia" + (lib.optionalString cli "-cli");
  version = "unstable-2023-12-21";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    rev = "d9d358481781f238dfd3d2e90060a64d90fb024a";
    hash = "sha256-Ho60NVIrk3XQp6xQlyrs9d4DylAkNJ5Rf5EFSgC9xq8=";
  };

  nativeBuildInputs = [
    pkg-config
    atkmm
    wrapGAppsHook
  ] ++ (if cli then [
    ffmpeg-full
    rustPlatform.bindgenHook
  ] else [
    #fontconfig
  ]);
  buildInputs = [
    gtk3
    alsa-lib
    atkmm
  ] ++ (if cli then [
    ffmpeg-full
  ] else [
    fontconfig
  ]);

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "mpeg_encoder-0.2.1" = "sha256-+BNZZ1FIr1374n8Zs1mww2w3eWHOH6ENOTYXz9RT2Ck=";
      "glyphon-0.3.0" = "sha256-Uw1zbHVAjB3pUfUd8GnFUnske3Gxs+RktrbaFJfK430=";
      "iced_core-0.12.0" = "sha256-9xyUXXq7/bf6KnWTD5GPC3NOtVHXICRzra++wBTA5O8=";
    };
  };

  cargoBuildFlags = [ "--package" pname ];

  postInstall = lib.optionalString (!cli) ''
    install -D flatpak/com.github.polymeilex.neothesia.desktop -t $out/share/applications
    install -D flatpak/com.github.polymeilex.neothesia.png -t $out/share/icons/hicolor/256x256/apps
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader libxkbcommon ]}
    )
  '';

  meta = with lib; {
    description = (if cli then "A CLI program encoding visualisations of MIDI files into video" else "A GUI program visualising MIDI input and files by piano with sound");
    longDescription = (if cli then ''
      neothesia-cli is the CLI version of Neothesia.

      When executing the program, you input the path to the MIDI file as the first argument. It will then render the notes flying towards a piano where a key lights up when a note is played. This is encoded into a video file.
    '' else ''
      Neothesia is a GUI program which can play MIDI files, visualising the notes on a piano it plays for you or which you play with MIDI input. Before the notes are played, they fly towars the piano.

      It plays the notes through the sound output too. The default instrument sound can be changed by loading SoundFont files.

      Neothesia may help you to learn how to play on the piano.
    '');
    homepage = "https://github.com/PolyMeilex/Neothesia";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = pname;
  };
}
