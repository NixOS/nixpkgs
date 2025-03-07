{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-yYuSciMsQudGqBPNqj28TZgCGtZb9j7mtEkBR8tbEm4=";
  };

  vendorHash = "sha256-UZ1todyWnxRTnqEGc/2rM+JCZPWYG/WA+OnivpB6JGI=";

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
