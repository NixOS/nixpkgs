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
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-mesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4W2G8NzVvcGp6nmCn4Wt9OUR9c7yceKdhDFb/RAk20=";
  };

  cargoHash = "sha256-3292/Q9OCoxkIOgOwAle37Ltozt1CDGGeXw6lqT91kU=";

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
