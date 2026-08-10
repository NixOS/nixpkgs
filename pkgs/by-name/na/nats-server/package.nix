{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "nats-server";
  version = "2.14.4";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jbw+R1na8tjTLyKJC/KDPhA1G1jgNxMhC+xD38IWH2k=";
  };

  vendorHash = "sha256-Lmbacb85+hTe4QoeO72aPOytZQiMQCymOelmGwh0/2E=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      swdunlop
      derekcollison
    ];
  };
})
