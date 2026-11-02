{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "nats-server";
  version = "2.15.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZQY0Q6YEpWVbHLI9nO6aEYItU0lKe+npKr6ASDT7KCg=";
  };

  vendorHash = "sha256-qzGUFmsKDac2Yu8jnVhfbj7vzJaur13Th0bydzRq+sc=";

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
