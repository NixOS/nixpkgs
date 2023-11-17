{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CyQKQNuCJLtm73ngrGtUmVUfiseXEp2fcKVGvQ1ET5A=";
  };

  vendorHash = "sha256-Q8Xw2vuxiYpkY0/gQlUVWO7WQszv2x1cvbV03Wi1GNg=";

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
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
    mainProgram = "dnscontrol";
  };
}
