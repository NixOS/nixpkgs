{ lib
, buildGoModule
, fetchFromGitHub
, testers
, kool
}:

buildGoModule rec {
  pname = "kool";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
    hash = "sha256-AbE0MT55LQgDY/WZRs+kCfreLYtSyzmXkYIQmJC4Hbo=";
  };

  vendorHash = "sha256-wzTsd2ITwnPFc85bXoZLLb9wKvHYOgnb1FGiFXLkkiE=";

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
    maintainers = with maintainers; [ figsoda ];
  };
}
