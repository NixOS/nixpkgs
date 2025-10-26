{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "nats-server";
  version = "2.12.5";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-23qXVxAxtoyvFCPL1I73eJv524NzBRE1gJYnYzm3LvE=";
  };

  vendorHash = "sha256-2P7O4LPz2Ky6tT/mU+0jK/j4mxroPjPQIOLznVYqfOM=";

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
