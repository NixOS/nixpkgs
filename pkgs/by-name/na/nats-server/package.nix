{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "nats-server";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SvgOts4bI60vKVDw5IZzn3PIoXVXk3sysqDf3doJ164=";
  };

  vendorHash = "sha256-/tmb8bd89+BWmbt6mJyRiFPvFSRMoU6eXr4WnWS0oog=";

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
