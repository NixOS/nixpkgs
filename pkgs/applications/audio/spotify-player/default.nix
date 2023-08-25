{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, cmake
, alsa-lib
, dbus
, fontconfig
, libsixel
}:

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
    alsa-lib
    dbus
    fontconfig
    libsixel
  ];

  buildNoDefaultFeatures = true;

  buildFeatures = [
    "rodio-backend"
    "media-control"
    "image"
    "lyric-finder"
    "daemon"
    "notify"
    "streaming"
    "sixel"
  ];

  meta = with lib; {
    description = "A command driven spotify player";
    homepage = "https://github.com/aome510/spotify-player";
    changelog = "https://github.com/aome510/spotify-player/releases/tag/v${version}";
    mainProgram = "spotify_player";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
