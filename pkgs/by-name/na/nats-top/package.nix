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
    repo = pname;
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    changelog = "https://github.com/nats-io/nats-top/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats-top";
  };
}
