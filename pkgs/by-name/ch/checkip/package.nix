{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.47.7";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = "checkip";
    tag = "v${version}";
    hash = "sha256-bjKRHIY9OIEft//g8VHKHTUrwWn8UU38SPP4IdPbIQE=";
  };

  vendorHash = "sha256-hTjSOufyrOKdY6wdPXvbpXwgWiHIRI+t4ByqHBY6cPQ=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Requires network
  doCheck = false;

  meta = {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "checkip";
  };
}
