{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  protobuf,
  libloragw-2g4,
  libloragw-sx1301,
  libloragw-sx1302,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-concentratord";
  version = "4.5.3";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${version}";
    hash = "sha256-D/zp3stjV0EUnUZlEVQ7YwFlczTxG0f0ABPban0JhPM=";
  };

  cargoHash = "sha256-7l/42l1rFX7HXdhgA34FXWpQjksGCnHeARC5YupA2nE=";

  buildInputs = [
    libloragw-2g4
    libloragw-sx1301
    libloragw-sx1302
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  updateScript = nix-update-script { };

  meta = {
    description = "Concentrator HAL daemon for LoRa gateways";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    platforms = lib.platforms.linux;
    mainProgram = "chirpstack-concentratord";
  };
}
