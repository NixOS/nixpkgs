{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule rec {
  pname = "sish";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${version}";
    hash = "sha256-RolkaMIhAZmUJtbB7218iAeEWS4a4NJOl2ZbPufZakQ=";
  };

  vendorHash = "sha256-0dtfZp8hzoPc3oQN6E7T8ZOhDmU2JeZ3YcB3QMUoPKI=";

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
