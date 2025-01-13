{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  alsa-lib,
  lame,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "downonspot";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "oSumAtrIX";
    repo = "DownOnSpot";
    rev = "refs/tags/v${version}";
    hash = "sha256-h/BKVFzvPq9FhX4wZzlIzoegK8nPEt+mR7oKpRC5eV0=";
  };

  # Use official public librespot version
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-2oPpi9MgQpvvjMJ5G+OkL8Gyemx82IHLjuAz+S8tI3E=";

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
