{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "omada-exporter";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "charlie-haley";
    repo = "omada_exporter";
    rev = "v${version}";
    sha256 = "sha256-zJBwGWY9/DqcK4Oew8DbJ8R/hssVSCIhtqT5MSt4/00=";
  };

  vendorHash = "sha256-m4zc2/BVvhCuk+WWxBu283qF/kdeRZdYGv3N3zIslgU=";

  meta = {
    description = "Exporter for metrics from TP-Link Omada SDN Controller";
    homepage = "https://github.com/charlie-haley/omada_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crutonjohn ];
    mainProgram = "omada_exporter";
  };
}
