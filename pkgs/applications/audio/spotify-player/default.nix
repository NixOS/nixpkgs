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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bHPWpx8EJibr2kNuzuGAQPZ0DE6qeJwIRYDy+NFS/PQ=";
  };

  cargoSha256 = "sha256-QeQ3PYI5RmbJ+VQ9hLSTXgQXVVoID5zbRqSTrbWzVy8=";

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
