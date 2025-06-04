{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nats-top,
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-top";
    tag = "v${version}";
    hash = "sha256-NOU0U1hyP9FCSLK0ulf28cx1K0/KWKQd+t3KtaVqWWo=";
  };

  vendorHash = "sha256-BQzOlX7Zrtlcd6+O92JoouzC1QCCbgRAeJoYn/runYA=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = nats-top;
      version = "v${version}";
    };
  };

  meta = {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    changelog = "https://github.com/nats-io/nats-top/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nats-top";
  };
}
