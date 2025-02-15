{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-gateway-mesh";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-mesh";
    rev = "v${version}";
    hash = "sha256-PU4mEIRzwz8vlTpYvFGCylu+EMEdrr3oC8e1LR3nWds=";
  };

  cargoHash = "sha256-7zMGBgVg8pZurO4CxoYD5SBElCIQFm5Rmx/IxOkh1sY=";

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
