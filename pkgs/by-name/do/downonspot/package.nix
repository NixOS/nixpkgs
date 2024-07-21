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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "oSumAtrIX";
    repo = "DownOnSpot";
    rev = "refs/tags/v${version}";
    hash = "sha256-PA11R/hVAmismayE8uU03P0eeNnrgpD2HxbMW0vlk3k=";
  };

  # Use official public librespot version
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-jdscYr4Emm2+mWXbxfhU1rp855tsGY5hrdJsDEfXeUo=";

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
