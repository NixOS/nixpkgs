{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "assign-lb-ip";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Nordix";
    repo = "assign-lb-ip";
    tag = "v${version}";
    hash = "sha256-Sfi58wcX61HNCmlDoparTqnfsuxu6barSnV0uYlC+ng=";
  };

  vendorHash = "sha256-N78a0pjs2Bg2Bslk/I0ntL88ui4IkRGenL0Pn17Lt/w=";

  meta = {
    description = "Assigns loadBalancerIP address to a Kubernetes service for testing purposes";
    mainProgram = "assign-lb-ip";
    homepage = "https://github.com/Nordix/assign-lb-ip";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ starcraft66 ];
  };
}
