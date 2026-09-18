{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bird-exporter";
  version = "1.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V/ouf+NcJQhkSPYl5Ysisbs3cgOma8LlXezndDz36qw=";
  };

  vendorHash = "sha256-xNqLRIn5SkEo9L2p1ThlsNuTboz4dxyBw9hEpew5+V8=";

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
