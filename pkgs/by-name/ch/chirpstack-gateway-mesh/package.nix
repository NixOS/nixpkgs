{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-gateway-mesh";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-mesh";
    tag = "v${version}";
    hash = "sha256-AmIKAEAUO33FIipy478JIjjqGfy/2GA1UymE9BZ86VQ=";
  };

  cargoHash = "sha256-IHft2/zjZoWkOeJpA7YKaSfyqPsd/3h7NZlW0irxPXA=";

  nativeBuildInputs = [ protobuf ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Turn LoRa gateways into a relays for extending the range of LoRa networks";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-gateway-mesh";
  };
}
