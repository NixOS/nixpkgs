{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "r53-ddns";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "r53-ddns";
    rev = "v${version}";
    sha256 = "sha256:1pvd1karq1p81rkq2n7mh040n29f7wb8701ax6g2sqm1yz7gxd08";
  };

  vendorSha256 = "sha256:1jhwds57gi548ahnh5m342csrs5rv9ysy7fqmfvg5w2s9slswq77";

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/fleaz/r53-ddns";
    description = "A DIY DynDNS tool based on Route53";
    maintainers = with maintainers; [ fleaz ];
  };
}
