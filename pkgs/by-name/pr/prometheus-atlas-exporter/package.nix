{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "atlas-exporter";
  version = "1.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "atlas_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7weH1in1JMgiQ8qtCylse3NrO1hrvWVdEzPzLcTsso=";
  };

  vendorHash = "sha256-UeXcNY82JoBmJSb8DXEFNlDv09dyD4R/nzxslosfuP0=";

  meta = {
    description = "Prometheus exporter for RIPE Atlas measurement results";
    mainProgram = "atlas_exporter";
    homepage = "https://github.com/czerwonk/atlas_exporter";
    changelog = "https://github.com/czerwonk/atlas_exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ clerie ];
  };
})
