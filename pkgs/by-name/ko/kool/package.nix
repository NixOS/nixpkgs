{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kool,
}:

buildGoModule rec {
  pname = "kool";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
    hash = "sha256-UVdkymG9Ni83NhGRAXalJiLbpn3xzNl0quew+vDfyec=";
  };

  vendorHash = "sha256-3PLSFPL0S18Bb6CB4UOgtRcUMbePHweDlrpAIhTho7M=";

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
