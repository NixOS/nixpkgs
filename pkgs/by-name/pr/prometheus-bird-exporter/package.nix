{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bird-exporter";
  version = "1.4.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-uR3/2ktVxzEZOy57eFopLFsAuiw03e9WZn2QC4/GNVc=";
  };

  vendorHash = "sha256-seTykqpdYQiWp8CoTAJ62rzxDaLFqjWe8y5YMu8Ypm8=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = {
    description = "Prometheus exporter for the bird routing daemon";
    mainProgram = "bird_exporter";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
  };
})
