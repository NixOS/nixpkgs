{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "dynacat";
  version = "3.0.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Panonim";
    repo = "dynacat";
    tag = finalAttrs.version;
    hash = "sha256-ljJAAvwEy6qR48fatbHxDplc/bsLbuV9qsJ3Dzyys9k=";
  };

  vendorHash = "sha256-lq1iJ0ZiKt68jFrVs6TJMewbO1kswhew8b4nh94ufjk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Panonim/dynacat/internal/dynacat.buildVersion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      service = nixosTests.dynacat;
    };
  };

  meta = {
    description = "Self-hosted dashboard focused on dynamic updates and integrations, forked from Glance";
    homepage = "https://github.com/Panonim/dynacat";
    changelog = "https://github.com/Panonim/dynacat/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ andreszb ];
    mainProgram = "dynacat";
  };
})
