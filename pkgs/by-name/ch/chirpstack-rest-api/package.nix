{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-YSMdE0f3usedyUItSvdtJ77L/x4rwrgIJa1TTg9ODek=";
  };

  vendorHash = "sha256-+lAfgFb45WxZYh5fzONECRwTlXA64nl58rfstOPsDEg=";

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
}
