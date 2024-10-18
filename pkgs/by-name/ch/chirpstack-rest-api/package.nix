{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-mL0p5gRSnCoQlYF0DyOt9FHW/jtNnl5hI+o8oJvJsT8=";
  };

  vendorHash = "sha256-thEoNN5j9frdb0KODZUkfQXGsrYwUCRcN74jwuXufU8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  doCheck = false;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "ChirpStack gRPC API to REST proxy";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-rest-api";
  };
}
