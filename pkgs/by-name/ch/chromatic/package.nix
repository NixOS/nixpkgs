{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, meson
, ninja
, pkg-config
, rustc
, cargo
, wrapGAppsHook4
, desktop-file-utils
, libxml2
, libadwaita
, portaudio
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "chromatic";
  version = "0-unstable-2023-08-05";

  src = fetchFromGitHub {
    owner = "nate-xyz";
    repo = "chromatic";
    rev = "ffaeb50dcce74bf3ba1b05f98423cf48f205f55e";
    hash = "sha256-E3v3UoQumBBYDOiXMfCRh5J7bfUCkettHth7SAresCE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-M3UMeGkLf57/I/9BIkyiMpOvjbKQJrOk+axf05vRoW0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    desktop-file-utils
    libxml2.bin # xmllint
  ];

  buildInputs = [
    libadwaita
    portaudio
    libpulseaudio
  ];

  meta = with lib; {
    description = "Fine-tune your instruments";
    longDescription = ''
      Fine-tune your instruments with Chromatic. Chromatic
      detects the frequency of audio input, converts it to
      a musical note with the correct semitone and octave,
      and displays the cents error. Cents are displayed on
      an analog gauge to make tuning more visually intuitive.
      Requires PulseAudio or PipeWire.
    '';
    homepage = "https://github.com/nate-xyz/chromatic";
    license = licenses.gpl3Plus;
    mainProgram = "chromatic";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
