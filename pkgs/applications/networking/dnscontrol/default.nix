{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.8.2";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    rev = "v${version}";
    hash = "sha256-9myo073/yl9CWwmVb3Gkihf6I/60kSOl0Pk8+dE39KM=";
  };

  vendorHash = "sha256-jOLFqCeBxQLXgUAdDbk/QnPBAtMBQi5VR+oKjgZLb28=";

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
