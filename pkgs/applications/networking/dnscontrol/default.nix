{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fYQqH/J027XJPML/qKMpuu2Nxuvb0cyjOu2czLH8SoM=";
  };

  vendorSha256 = "sha256-225TR9jTZSGEJZz3csl/pR/v2unUK67l08x5ESQTJzA=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
