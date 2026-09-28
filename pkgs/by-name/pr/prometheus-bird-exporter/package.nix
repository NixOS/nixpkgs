{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bird-exporter";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NidsYTeYdFr+chY+3h2G4JUE3v9BX9yiv/nlfK/lyKs=";
  };

  vendorHash = "sha256-nBZDxAUBYJMIXF3Yh9Br3PI38Gn8NuI+MEV+hQsvx6Q=";

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
