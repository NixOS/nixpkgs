{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XH9o1DTwG5ne5TZDgsS4HfC5WqLXc16JtjkKQtiE8z0=";
  };

  vendorSha256 = "sha256-iVyLNPvmzkI46Cp0SgbxK6xIQspJjpYjqPf3mOMoZvU=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
