{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sbomit";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SBOMit";
    repo = "sbomit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/tst1XGwW8LTuEFbY1KA+C93TNapVJsYstFY9oPH8yA=";
  };

  vendorHash = "sha256-R3WBmmoh+YJMJlo+OgSXU50YcEfLQWAxkBYHPAT3NZM=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to generate SBOMs";
    homepage = "https://github.com/SBOMit/sbomit";
    changelog = "https://github.com/SBOMit/sbomit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sbomit";
  };
})
