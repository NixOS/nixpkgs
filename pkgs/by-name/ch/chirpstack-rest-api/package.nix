{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "chirpstack-rest-api";
  version = "4.20.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Eu+puCPRMcE+W6HMDeDX79qxp5d7QlnT3r4k2TFdsCY=";
  };

  vendorHash = "sha256-WYydjXGIOID64GB0UHvkNTExrc9nj7lhVCrJXP5/+CY=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "gRPC API to REST proxy for Chirpstack";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-rest-api";
  };
})
