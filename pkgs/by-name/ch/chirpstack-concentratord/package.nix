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
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-945ZJZ/OLoR/3dAC/PZHRRziyuLDZ+xfitF8jpvZ420=";
  };

  cargoHash = "sha256-cwm8ZSfml9B/OO5QzH1eUhoF/3DPUEEV0T/YL427X80=";

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
