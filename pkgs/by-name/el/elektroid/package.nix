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
  rubberband,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elektroid";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "dagargo";
    repo = "elektroid";
    rev = finalAttrs.version;
    hash = "sha256-9ySyjhnFXn4xzLjHbbo+WSpzQINsXKPgETdlJ4eqgvQ=";
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
    rubberband
    zlib
  ];

  meta = {
    description = "Sample and MIDI device manager";
    homepage = "https://github.com/dagargo/elektroid";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ camelpunch ];
  };
})
