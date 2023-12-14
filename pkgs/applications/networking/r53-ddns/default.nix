{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "r53-ddns";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "r53-ddns";
    rev = "v${version}";
    sha256 = "sha256-KJAPhSGaC3upWLfo2eeSD3Vit9Blmbol7s8y3f849N4=";
  };

  vendorHash = "sha256-KkyMd94cejWkgg/RJudy1lm/M3lsEJXFGqVTzGIX3qM=";

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/fleaz/r53-ddns";
    description = "A DIY DynDNS tool based on Route53";
    maintainers = with maintainers; [ fleaz ];
    mainProgram = "r53-ddns";
  };
}
