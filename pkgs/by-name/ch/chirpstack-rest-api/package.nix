{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-0OeWrE+9YJTf72+1KTpySutjlY53QYqSdl8bwS2MY10=";
  };

  vendorHash = "sha256-5fP2v5JTsBkJ1SLx94HWLKwf5Jb3desLen3VxwER9vE=";

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
