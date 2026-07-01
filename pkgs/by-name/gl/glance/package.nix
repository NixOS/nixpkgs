{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "glance";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "glance";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2WFX1Gca7ign9i1zOQ9lRdtOSGq9QG33vIA5QTnq9E8=";
  };

  vendorHash = "sha256-a92V/duqvrWEb8QSJLA5rHYYZCcJ4fBC962SEr4FJDA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/glanceapp/glance/internal/glance.buildVersion=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      service = nixosTests.glance;
    };
  };

  meta = {
    homepage = "https://github.com/glanceapp/glance";
    changelog = "https://github.com/glanceapp/glance/releases/tag/v${finalAttrs.version}";
    description = "Self-hosted dashboard that puts all your feeds in one place";
    mainProgram = "glance";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dvn0
      defelo
    ];
  };
})
