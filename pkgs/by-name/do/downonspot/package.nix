{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, makeWrapper
, alsa-lib
, lame
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "downonspot";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "oSumAtrIX";
    repo = "DownOnSpot";
    rev = "refs/tags/v${version}";
    hash = "sha256-F0SW/qce7eEEDC4FQvO6eW9V4POkRK/WP8bMUBtzGIw=";
  };

  # Use official public librespot version
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-kLMV8jDadb2BryOqXGkiunQvZRjzjbVTh9Z+jHSSHbU=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    alsa-lib
    lame
  ];

  meta = with lib; {
    description = "Spotify downloader written in rust";
    homepage = "https://github.com/oSumAtrIX/DownOnSpot";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
    mainProgram = "down_on_spot";
  };
}
