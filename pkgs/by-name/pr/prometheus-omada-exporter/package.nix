{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "omada-exporter";
  version = "v0.13.0";

  src = fetchFromGitHub {
    owner = "charlie-haley";
    repo = "omada_exporter";
    rev = version;
    sha256 = "sha256-JedDF9uFUiYGwV6HATtbXDu08Ft0KRw08/sKSW+aqRo=";
  };

  vendorHash = "sha256-m4zc2/BVvhCuk+WWxBu283qF/kdeRZdYGv3N3zIslgU=";

  meta = with lib; {
    description = "Exporter for metrics from TP-Link Omada SDN Controller";
    homepage = "https://github.com/charlie-haley/omada_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ crutonjohn ];
  };
}
