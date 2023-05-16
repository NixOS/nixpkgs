{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "assign-lb-ip";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Nordix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Sfi58wcX61HNCmlDoparTqnfsuxu6barSnV0uYlC+ng=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-N78a0pjs2Bg2Bslk/I0ntL88ui4IkRGenL0Pn17Lt/w=";
=======
  vendorSha256 = "sha256-N78a0pjs2Bg2Bslk/I0ntL88ui4IkRGenL0Pn17Lt/w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Assigns loadBalancerIP address to a Kubernetes service for testing purposes";
    homepage    = "https://github.com/Nordix/assign-lb-ip";
    license     = licenses.asl20;
    maintainers = [ maintainers.starcraft66 ];
  };
}
