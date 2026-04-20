{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "nats-server";
  version = "2.12.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7fv0Zd48eVA9zwAVG2SLs3a/9r7983PgZpUzh1GuSUw=";
  };

  vendorHash = "sha256-3+FAZSymDO1iTAWcgjrczE43Fgz6EEwLgOBEbDH4OyY=";

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
