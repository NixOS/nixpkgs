{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sbomit";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SBOMit";
    repo = "sbomit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7lqe4yoOiu0g1d6a9b3hPVcqYLyJv6e0h3+ZLgudFg=";
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
