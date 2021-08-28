{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9lIjQaMYy0FGMkR29Es3BMIAcn+jQYudyFJHwezlXKM=";
  };

  vendorSha256 = "sha256-thvbqDhLdY+g/byFHJ9Tdiw8WYRccu4X1Rb0pdhE34E=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
