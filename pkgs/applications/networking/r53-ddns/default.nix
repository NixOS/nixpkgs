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

<<<<<<< HEAD
  vendorHash = "sha256-KkyMd94cejWkgg/RJudy1lm/M3lsEJXFGqVTzGIX3qM=";
=======
  vendorSha256 = "sha256-KkyMd94cejWkgg/RJudy1lm/M3lsEJXFGqVTzGIX3qM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/fleaz/r53-ddns";
    description = "A DIY DynDNS tool based on Route53";
    maintainers = with maintainers; [ fleaz ];
  };
}
