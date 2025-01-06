{
  alsa-lib,
  autoreconfHook,
  fetchFromGitHub,
  gtk3,
  json-glib,
  lib,
  libpulseaudio,
  libsamplerate,
  libsndfile,
  libzip,
  pkg-config,
  stdenv,
  zlib,
}:

let
  version = "3.1";
in
stdenv.mkDerivation {
  inherit version;

  pname = "elektroid";

  src = fetchFromGitHub {
    owner = "dagargo";
    repo = "elektroid";
    rev = version;
    hash = "sha256-YJcvJlnRUhwjQ6P3jgjyDtoJhuije1uY77mGNGZure0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    gtk3
    json-glib
    libpulseaudio
    libsamplerate
    libsndfile
    libzip
    zlib
  ];

  meta = {
    description = "Sample and MIDI device manager";
    homepage = "https://github.com/dagargo/elektroid";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ camelpunch ];
  };
}
