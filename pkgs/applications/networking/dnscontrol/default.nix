{ lib, buildGoModule, fetchFromGitHub, testers, dnscontrol }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    rev = "v${version}";
    hash = "sha256-E5/7qAK2pvl1ADioF7Iwe9SgCE6tVaQdtOAwNo3XZx8=";
  };

  vendorHash = "sha256-5VTC6Y3Bs2ViW5/O8TeD0i6Boeu71b9C+B/3O73bCbk=";

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
