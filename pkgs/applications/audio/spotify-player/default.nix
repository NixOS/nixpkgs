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
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+YPtu3hsKvk2KskVSpqcFufnWL5PxN8+xbkcz/JXW6g=";
  };

  cargoHash = "sha256-WgQ+v9dJyriqq7+WpXpPhjdwm2Sr0jozA1oW2inSPik=";

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
