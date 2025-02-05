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
  version = "4.4.6";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${version}";
    hash = "sha256-O5QevCYFZEJzZcLM3wh9b+RvbkFwLlvIcFhVbhVDOXU=";
  };

  cargoHash = "sha256-oRy8yGBRD/PGh+RtY9nk03oV6SRBGucRABwfgJbnuxM=";

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
