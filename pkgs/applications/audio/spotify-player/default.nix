{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, cmake
# deps for audio backends
, alsa-lib
, libpulseaudio
, portaudio
, libjack2
, SDL2
, gst_all_1
, dbus
, fontconfig
, libsixel

# build options
, withStreaming ? true
, withDaemon ? true
, withAudioBackend ? "rodio" # alsa, pulseaudio, rodio, portaudio, jackaudio, rodiojack, sdl
, withMediaControl ? true
, withLyrics ? true
, withImage ? true
, withNotify ? true
, withSixel ? true
}:

assert lib.assertOneOf "withAudioBackend" withAudioBackend [ "" "alsa" "pulseaudio" "rodio" "portaudio" "jackaudio" "rodiojack" "sdl" "gstreamer" ];

rustPlatform.buildRustPackage rec {
  pname = "spotify-player";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5+YBlXHpAzGgw6MqgnMSggCASS++A/WWomftX8Jxe7g=";
  };

  cargoHash = "sha256-PIYaJC3rVbPjc2CASzMGWAzUdrBwFnKqhrZO6nywdN8=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    dbus
    fontconfig
  ]
    ++ lib.optionals withSixel [ libsixel ]
    ++ lib.optionals (withAudioBackend == "alsa") [ alsa-lib ]
    ++ lib.optionals (withAudioBackend == "pulseaudio") [ libpulseaudio ]
    ++ lib.optionals (withAudioBackend == "rodio") [ alsa-lib ]
    ++ lib.optionals (withAudioBackend == "portaudio") [ portaudio ]
    ++ lib.optionals (withAudioBackend == "jackaudio") [ libjack2 ]
    ++ lib.optionals (withAudioBackend == "rodiojack") [ alsa-lib libjack2 ]
    ++ lib.optionals (withAudioBackend == "sdl") [ SDL2 ]
    ++ lib.optionals (withAudioBackend == "gstreamer") [ gst_all_1.gstreamer gst_all_1.gst-devtools gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ];

  buildNoDefaultFeatures = true;

  buildFeatures = [ ]
    ++ lib.optionals (withAudioBackend != "") [ "${withAudioBackend}-backend" ]
    ++ lib.optionals withMediaControl [ "media-control" ]
    ++ lib.optionals withImage [ "image" ]
    ++ lib.optionals withLyrics [ "lyric-finder" ]
    ++ lib.optionals withDaemon [ "daemon" ]
    ++ lib.optionals withNotify [ "notify" ]
    ++ lib.optionals withStreaming [ "streaming" ]
    ++ lib.optionals withSixel [ "sixel" ];

  meta = {
    description = "A terminal spotify player that has feature parity with the official client";
    homepage = "https://github.com/aome510/spotify-player";
    changelog = "https://github.com/aome510/spotify-player/releases/tag/v${version}";
    mainProgram = "spotify_player";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya xyven1 ];
  };
}
