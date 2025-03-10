{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  goreman,
}:

buildGoModule rec {
  pname = "goreman";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "v${version}";
    hash = "sha256-hOFnLxHsrauOrsbJYKNrwFFT5yYX/rdZUVjscBIGDLo=";
  };

  vendorHash = "sha256-Udm0xdrW8Aky26oxUhdbpsNTWziZxkM0G1ZRKLwyl1Q=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = goreman;
    command = "goreman version";
  };

  meta = with lib; {
    description = "foreman clone written in go language";
    mainProgram = "goreman";
    homepage = "https://github.com/mattn/goreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
