{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bird-exporter";
  version = "1.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rSZFSIg17t1gcWYVHLEW54dSnqx889TC0R4UAZoBHMQ=";
  };

  vendorHash = "sha256-anmrvgKfcuzky3tnniVvqdJs8SuJcJJStusVY3q9ago=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    changelog = "https://github.com/czerwonk/bird_exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "bird_exporter";
  };
})
