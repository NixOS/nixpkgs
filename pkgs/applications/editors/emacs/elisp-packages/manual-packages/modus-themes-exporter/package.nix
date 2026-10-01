{
  lib,
  melpaBuild,
  fetchFromGitHub,
  modus-themes,
  nix-update-script,
}:
melpaBuild {
  pname = "modus-themes-exporter";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "modus-themes-exporter";
    rev = "a19c4b0f22d353afcd441fbbc6c0565858a86c9b";
    hash = "sha256-/PCCArQUV1uhhbOC3fqSuUkgDqc4+QlLubTtjx8/vGc=";
  };

  packageRequires = [ modus-themes ];
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Export a Modus themes to another application";
    homepage = "https://github.com/protesilaos/modus-themes-exporter";
    maintainers = [ lib.maintainers.HeitorAugustoLN ];
    license = lib.licenses.gpl3Plus;
  };
}
