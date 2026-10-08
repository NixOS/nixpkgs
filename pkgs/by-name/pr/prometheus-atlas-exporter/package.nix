{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "atlas-exporter";
  version = "1.0.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "atlas_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xCDqu6+J2xIk+BnrR42jsDsbI+ZAr4kC+euBW0LM6Vk=";
  };

  vendorHash = "sha256-TMpImTanecjlhCsQvIG/6TdGvs4ZAqLhX6qSO6AboMI=";

  meta = {
    description = "Prometheus exporter for RIPE Atlas measurement results";
    mainProgram = "atlas_exporter";
    homepage = "https://github.com/czerwonk/atlas_exporter";
    changelog = "https://github.com/czerwonk/atlas_exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ clerie ];
  };
})
