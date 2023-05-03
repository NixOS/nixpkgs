{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.31.2";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vKfbL2a/5rTVsG0rDs/D0t5eXDNWlbwURI2FYzGu9lY=";
  };

  vendorHash = "sha256-BE/UnJw5elHYmyB+quN89ZkrlMcTjaVN0T2+h8cpPS8=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
