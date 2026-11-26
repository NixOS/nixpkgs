{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bird-exporter";
  version = "1.7.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JwzC+XVHT91qRHSSk8ARwKhlz8wK88MB1SpJ0+Bb7cc=";
  };

  vendorHash = "sha256-u5dNhZal7YwRYBaR4+1P5MloDzeIDVMRQhcm7Q+Lkeo=";

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
