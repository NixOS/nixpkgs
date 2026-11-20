{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "atlas-exporter";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "atlas_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6H/C/prFNfPmZD9C+kLrok/AOVgiWaY3DdjdqktHQmQ=";
  };

  vendorHash = "sha256-zHLeH2ExPpvOzAfm1llAPtac49AbYmnuTdYMTUNMb1Q=";

  meta = {
    description = "Prometheus exporter for RIPE Atlas measurement results";
    mainProgram = "atlas_exporter";
    homepage = "https://github.com/czerwonk/atlas_exporter";
    changelog = "https://github.com/czerwonk/atlas_exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ clerie ];
  };
})
