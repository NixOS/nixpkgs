{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "goverter";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-56TDLre7HFlTeR8xcfDUrED2wy2ajpTWdA810zZfg98=";
  };

  vendorHash = "sha256-wStuQhxrzd+LyHQi+k6ez6JT1xzZcPjJa09WqX70bys=";

  subPackages = [ "cmd/goverter" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate type-safe Go converters by defining function signatures";
    homepage = "https://github.com/jmattheis/goverter";
    changelog = "https://goverter.jmattheis.de/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "goverter";
  };
})
