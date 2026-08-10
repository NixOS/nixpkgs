{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "goreman";
  version = "0.3.19";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WVgMJ/9HTwNY7M0hXW7ag8vyQkIrUg+n0e7RX3LQ6a4=";
  };

  vendorHash = "sha256-KaqihJ5lu65EQQZGZ6Ym1Q/7jbN6zBdZ2AFovTpQ9S8=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "goreman version";
  };

  meta = {
    description = "Foreman clone written in go language";
    mainProgram = "goreman";
    homepage = "https://github.com/mattn/goreman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
})
