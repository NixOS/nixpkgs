{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    rev = "v${version}";
    hash = "sha256-vH+BHTDQNFZTZjTvxV8ItGkTDj6G5q1t2YC/1LVYXUs=";
  };

  vendorHash = "sha256-InLafJxxOVKGW0bhithJV7qYFjsgDEDGeTBwGvPVG4E=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://dnscontrol.org/";
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "dnscontrol";
  };
}
