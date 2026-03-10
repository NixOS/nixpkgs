{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nats-top,
}:

buildGoModule (finalAttrs: {
  pname = "nats-top";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-top";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NOU0U1hyP9FCSLK0ulf28cx1K0/KWKQd+t3KtaVqWWo=";
  };

  vendorHash = "sha256-BQzOlX7Zrtlcd6+O92JoouzC1QCCbgRAeJoYn/runYA=";

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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nats-top";
  };
})
