{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nats-top,
}:

buildGoModule (finalAttrs: {
  pname = "nats-top";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-top";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VzHPetIgPR/+1O29q1+70xry3Z6elv2CinzEn6zd9uQ=";
  };

  vendorHash = "sha256-Ewq0LUSJdbaSRKD6D28XQHLoY012o9vfhup5PQ6MFts=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = nats-top;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    changelog = "https://github.com/nats-io/nats-top/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nats-top";
  };
})
