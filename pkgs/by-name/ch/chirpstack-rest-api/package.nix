{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "chirpstack-rest-api";
  version = "4.19.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DOQ6S0o9kWYdIoR/SWW29hhsVJ9gKE3cRHrunhXHXJg=";
  };

  vendorHash = "sha256-5TEXM7sigSN6NpWUC3bv4rXhuArz1j8+R8P/arXa5rg=";

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
