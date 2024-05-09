{ lib, buildGoModule, fetchFromGitHub, testers, dnscontrol }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    rev = "v${version}";
    hash = "sha256-7Gmb28/k72wfd2bWDCk7onUBAzNs6b5q52lCn0WB3B8=";
  };

  vendorHash = "sha256-uYClwaFSj03K4YD/jvn67sIko72jDqd5Fv2zoCXZZbw=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  passthru.tests = {
    version = testers.testVersion {
      command = "${lib.getExe dnscontrol} version";
      package = dnscontrol;
    };
  };

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://dnscontrol.org/";
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "dnscontrol";
  };
}
