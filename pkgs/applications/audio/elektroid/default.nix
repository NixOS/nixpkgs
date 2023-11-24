{ alsa-lib
, autoreconfHook
, fetchFromGitHub
, gtk3
, json-glib
, lib
, libpulseaudio
, libsamplerate
, libsndfile
, libzip
, pkg-config
, stdenv
, zlib
}:

let
  version = "2.5.2";
in
stdenv.mkDerivation {
  inherit version;

  pname = "elektroid";

  src = fetchFromGitHub {
    owner = "dagargo";
    repo = "elektroid";
    rev = version;
    sha256 = "sha256-wpPHcrlCX7RD/TGH2Xrth+oCg98gMm035tfTBV70P+Y=";
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

  meta = with lib; {
    description = "Sample and MIDI device manager";
    homepage = "https://github.com/dagargo/elektroid";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ camelpunch ];
  };
}
