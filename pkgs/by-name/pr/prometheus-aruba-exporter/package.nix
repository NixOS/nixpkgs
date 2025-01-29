{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "prometheus-aruba-exporter";
  version = "unstable-2023-01-18";

  src = fetchFromGitHub {
    owner = "slashdoom";
    repo = "aruba_exporter";
    rev = "ca30cd687f949c9b0ac4e451c17583e6a9eb835a";
    sha256 = "sha256-U4J+j3AGNwniA+YmeWopAus/pxQIe6WIZWQJgO/0uJE=";
  };

  vendorHash = "sha256-1XYwrajzKoWOPg4aKE5rJVjWZ9RWBKD/kANOZHtWJCk=";

  meta = {
    description = "Prometheus exporter for metrics from Aruba devices including ArubaSwitchOS, ArubaOS-CX, ArubaOS (Instant AP and controllers/gateways)";
    mainProgram = "aruba_exporter";
    homepage = "https://github.com/slashdoom/aruba_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ netali ];
  };
}
