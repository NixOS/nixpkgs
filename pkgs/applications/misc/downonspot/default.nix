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
  version = "unstable-2023-11-26";

  src = fetchFromGitHub {
    owner = "oSumAtrIX";
    repo = "DownOnSpot";
    rev = "406fbf137306208bcb9835ad3aa92b0edbc01805";
    hash = "sha256-gY5pDZ5EwKhBmV8VyuKW/19BgfPSIZSp9rEI/GuonYQ=";
  };

  # Use official public librespot version
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-CG9QY9Nfy/dxzvSPG2NB2/6yjTvdoDI76PRSaM138Wk=";

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
    description = "A Spotify downloader written in rust";
    homepage = "https://github.com/oSumAtrIX/DownOnSpot";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
