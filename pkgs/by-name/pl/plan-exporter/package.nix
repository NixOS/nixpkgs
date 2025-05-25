{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "plan-exporter";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "agneum";
    repo = "plan-exporter";
    tag = "v${version}";
    hash = "sha256-Csp57wmkDA8b05hmKbk1+bGtORFgNls7I01A0irTKao=";
  };

  vendorHash = null;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Query plan exporter for psql";
    homepage = "https://github.com/agneum/plan-exporter";
    changelog = "https://github.com/agneum/plan-exporter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ autra ];
  };
}
