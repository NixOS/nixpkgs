{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "goreman";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hOFnLxHsrauOrsbJYKNrwFFT5yYX/rdZUVjscBIGDLo=";
  };

  vendorHash = "sha256-Udm0xdrW8Aky26oxUhdbpsNTWziZxkM0G1ZRKLwyl1Q=";

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
