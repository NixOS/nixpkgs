{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kool,
}:

buildGoModule rec {
  pname = "kool";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
    hash = "sha256-yUJbuMOLEa9LVRltskSwD0XBdmwwLcEaLYUHsSQOiCk=";
  };

  vendorHash = "sha256-IqUkIf0uk4iUTedTO5xRzjmJwHS+p6apo4E0WEEU6cc=";

  ldflags = [
    "-s"
    "-w"
    "-X=kool-dev/kool/commands.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = kool;
    };
  };

  meta = with lib; {
    description = "From local development to the cloud: development workflow made easy";
    mainProgram = "kool";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
