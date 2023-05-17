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
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-c+CbIDg4WlzRStiA+yBkjfSmMJ183tLBGiK340bZgnA=";
  };

  cargoHash = "sha256-nhRXFxSrzkq3SdJ4ZmWlKl7SwxwOz6ZYboIsBmgdFJ8=";

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
    changelog = "https://github.com/aome510/spotify-player/releases/tag/v${version}";
    mainProgram = "spotify_player";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
