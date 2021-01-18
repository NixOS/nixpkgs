{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bnsd1kx0ji2s3w1v7sskc3x82avaqjn2arnax55bmh1yjma6z8p";
  };

  vendorSha256 = "0ppcrp6jp23ycn70mcgi5bsa0hr20hk7044ldw304krawy2vjgz8";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
