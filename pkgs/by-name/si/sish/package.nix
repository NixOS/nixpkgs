{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule rec {
  pname = "sish";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${version}";
    hash = "sha256-zw8zWvyApozHXROZV/o4hZ1EEl0u12snRxjhsqtSrI0=";
  };

  vendorHash = "sha256-FQzmFyunNllbn4Vaj+kzLamIXDGdWn90TA577EkgI6c=";

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

  meta = {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sish";
  };
}
