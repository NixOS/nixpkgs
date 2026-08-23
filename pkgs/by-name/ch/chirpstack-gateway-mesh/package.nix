{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chirpstack-gateway-mesh";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-mesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rZJO36PUj1W5mO/eVjL5DXpqjMoHyiAzpH3ntkWzWso=";
  };

  cargoHash = "sha256-RlsacitNZUWC5hzbERudFaoPMqWdlLO5fdVU5b7ZM9M=";

  nativeBuildInputs = [ protobuf ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Turn LoRa gateways into relays for extending the range of LoRa networks";
    homepage = "https://www.chirpstack.io";
    changelog = "https://github.com/chirpstack/chirpstack-gateway-mesh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    platforms = lib.platforms.linux;
    mainProgram = "chirpstack-gateway-mesh";
  };
})
