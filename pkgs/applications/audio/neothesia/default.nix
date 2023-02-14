{ lib
, rustPlatform
, fetchFromGitHub
, cli ? false
, pkg-config
, alsa-lib
, wrapGAppsHook
, ffmpeg-full
, makeWrapper
, libxkbcommon
, libGL
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "neothesia" + (lib.optionalString cli "-cli");
  version = "unstable-2024-07-21";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    rev = "b29030a117badeb9891971261b857deca9cf91f2";
    hash = "sha256-7HLIfxd7k9RMccTxuH5MBQc9o9ynbWDrJbNjD3wMCL4=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ] ++ (if cli then [
    ffmpeg-full
  ] else [
    #fontconfig
  ]);
  buildInputs = [
  ] ++ (if cli then [
    ffmpeg-full
  ] else [
    alsa-lib
  ]);

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "mpeg_encoder-0.2.1" = "sha256-+BNZZ1FIr1374n8Zs1mww2w3eWHOH6ENOTYXz9RT2Ck=";
      "glyphon-0.5.0" = "sha256-OGXLqiMjaZ7gR5ANkuCgkfn/I7c/4h9SRE6MZZMW3m4=";
      "iced_core-0.13.0-dev" = "sha256-enPg3TzYMRVgTo6zcTxkUZpXxUWUZTkwmZuzm0CIShY=";
    };
  };

  cargoBuildFlags = [ "--package" pname ];

  postInstall = lib.optionalString (!cli) ''
    install -D default.sf2 -t $out/share/neothesia
    install -D flatpak/com.github.polymeilex.neothesia.desktop -t $out/share/applications
    install -D flatpak/com.github.polymeilex.neothesia.png -t $out/share/icons/hicolor/256x256/apps
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        libxkbcommon
        libGL
        wayland
      ]}
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
