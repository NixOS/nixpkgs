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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chirpstack-concentratord";
  version = "4.7.0-test.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dV16cJrYZ40cOzvwa9w2XEFOUwbYryFftXv5qLWzVSs=";
  };

  cargoHash = "sha256-AFfnMkZLCyivgX+csOYTSeS7Pdm1VG7Zbbdf8lUSgGc=";

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
})
