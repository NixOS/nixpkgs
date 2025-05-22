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
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "glance";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o2Yom40HbNKe3DMMxz0Mf2gG8zresgU52Odpj2H7ZPU=";
  };

  patches = [ ./update_purego.patch ];

  vendorHash = "sha256-esPtCg63A40mX9hADOhEa+NjNk+9MI/0qZG3uE91qxg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/glanceapp/glance/internal/glance.buildVersion=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
