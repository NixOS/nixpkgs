{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bvvh68k2xjmmwafwdsijf3yb4ff9wbsl2ibad627l1y4js5615z";
  };

  vendorSha256 = "05nwfxqgkpbv5i0365wpsnnaq528a7srycd1dsdlssz1cy7i0d31";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
