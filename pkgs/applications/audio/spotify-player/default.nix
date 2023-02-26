{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, cmake
, alsa-lib
, dbus
, fontconfig

# build options
, withStreaming ? true
, withAudioBackend ? "rodio"
, withMediaControl ? true
, withLyrics ? false
, withImage ? false
, withNotify ? false
, withSixel ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-player";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nWXXaRHTzCXmu4eKw88pKuWXgdG9n7azPeBbXYz+Fio=";
  };

  cargoHash = "sha256-y/qHiwZes4nVtjbFN/jL2LFugGpRKnYij7+XXZbqguQ=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    alsa-lib
    dbus
    fontconfig
  ];

  buildNoDefaultFeatures = true;

  buildFeatures = [ ]
    ++ lib.optionals withStreaming [ "streaming" ]
    ++ lib.optionals (withAudioBackend != "") [ "${withAudioBackend}-backend" ]
    ++ lib.optionals withMediaControl [ "media-control" ]
    ++ lib.optionals withLyrics [ "lyric-finder" ]
    ++ lib.optionals withImage [ "image" ]
    ++ lib.optionals withNotify [ "notify" ]
    ++ lib.optionals withSixel [ "sixel" ];

  meta = with lib; {
    description = "A fast, easy to use, and configurable terminal music player";
    homepage = "https://github.com/aome510/spotify-player";
    mainProgram = "spotify_player";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya Xyven1 ];
  };
}
