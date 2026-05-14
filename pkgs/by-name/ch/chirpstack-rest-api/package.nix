{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "chirpstack-rest-api";
  version = "4.18.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d8DoU5iqBtWLu8I0xzM8+ny16iylAbjRku7EC1m0o50=";
  };

  vendorHash = "sha256-b0m3a0U/XgRFR1lvfOUB1yQFZZ9j558WBiymnysjuGg=";

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
