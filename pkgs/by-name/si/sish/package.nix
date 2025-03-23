{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule rec {
  pname = "sish";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${version}";
    hash = "sha256-HsN/NQ82tHqdh295fSkJ8SW5oqKF8TJ4ck1VwmNZtk8=";
  };

  vendorHash = "sha256-8QNqq/FV8/eZcDnYiRayxsoDTPU+WgDYdURM0Mgzt8s=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${src.rev}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = sish;
    };
  };

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "sish";
  };
}
