{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kool,
}:

buildGoModule (finalAttrs: {
  pname = "kool";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = finalAttrs.version;
    hash = "sha256-81UhlEAk8ZNC/G6tV2g8+VZVVrLJVV6Dji2pjmWIYb8=";
  };

  vendorHash = "sha256-IqUkIf0uk4iUTedTO5xRzjmJwHS+p6apo4E0WEEU6cc=";

  ldflags = [
    "-s"
    "-w"
    "-X=kool-dev/kool/commands.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = kool;
    };
  };

  meta = {
    description = "From local development to the cloud: development workflow made easy";
    mainProgram = "kool";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
