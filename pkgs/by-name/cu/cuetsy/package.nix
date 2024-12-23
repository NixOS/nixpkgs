{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "cuetsy";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cuetsy";
    rev = "v${version}";
    hash = "sha256-dirzVR4j5K1+EHbeRi4rHwRxkyveySoM7qJzvOlGp+0=";
  };

  vendorHash = "sha256-CDa7ZfbVQOIt24VZTy4j0Dn24nolmYa0h9zgrJ3QTeY=";

  meta = {
    description = "Experimental CUE->TypeScript exporter";
    homepage = "https://github.com/grafana/cuetsy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bryanhonof ];
    mainProgram = "cuetsy";
  };
}
