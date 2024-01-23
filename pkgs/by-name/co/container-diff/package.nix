{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "container-diff";
  version = "unstable-2023-10-16";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "5d449781a18f91cc501ce3ee1c02fd198ead9b66";
    sha256 = "sha256-HjHcyPNDgzxxnlELh1tYhHwndgd9iJLlqFAbmFirT+I=";
  };

  vendorHash = "sha256-ix1EsRSDjWjbAN20j3wE8iPsU9W2dXVyTCqrVD8is5g=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/GoogleContainerTools/container-diff";
    description = "A tool for analyzing and comparing container images";
    license = lib.licenses.asl20;
    mainProgram = "container-diff";
    maintainers = with lib.maintainers; [ amarshall ];
  };
}
