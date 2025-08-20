{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.24";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/iKgRnoAjZX6hiUpPOXpCjY2FsX7JMpNSSCtWgcFLWQ=";
  };

  vendorHash = "sha256-aopqwxIfLFBdy4MFjyQCUKRUORosm4oHcScET9BW3D4=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      swdunlop
      derekcollison
    ];
  };
}
