{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${version}";
    hash = "sha256-H+2v90LI4WFQ8B7o1AFY2aV3SJcF3BgktpASjiVSvxE=";
  };

  vendorHash = "sha256-3B8ob5cVDL6adzEu5j5P7ZeVtJkQI3uJOAbzyIu8x20=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      swdunlop
      derekcollison
    ];
  };
}
