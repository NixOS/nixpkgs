{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-woiFCirM2psmwcKGgQngOJuYZDI2t81xkSzVi4svtXs=";
  };

  vendorHash = "sha256-3xT5WPBcEclXad8zBA+T7/M6fDmfMWljV8NuxvtvTsA=";

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
