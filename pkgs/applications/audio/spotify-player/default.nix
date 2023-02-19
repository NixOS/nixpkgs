{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, cmake
, alsa-lib
, dbus
, fontconfig
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-player";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iaDaPjh2wZXxBxBDhWp+hHrJZyXqw6HSzgCzbZj9iho=";
  };

  cargoHash = "sha256-I8n/fR1aOsSex2p0u5FaqoJCh2J0oMxkikS9aynxgpA=";

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

  buildFeatures = [
    "rodio-backend"
    "media-control"
    "image"
    "lyric-finder"
  ];

  meta = with lib; {
    description = "A command driven spotify player";
    homepage = "https://github.com/aome510/spotify-player";
    mainProgram = "spotify_player";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
