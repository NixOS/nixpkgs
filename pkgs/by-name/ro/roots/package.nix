{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "roots";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "roots";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACMRfWY/lhc3C/KVhuUyS1rgkSHGWPxZrmYt+pXupJI=";
  };

  vendorHash = "sha256-uxcT5VzlTCxxnx09p13mot0wVbbas/otoHdg7QSDt4E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/roots/version.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for exploring multiple root directories such as those in a monorepo project";
    homepage = "https://github.com/k1LoW/roots";
    changelog = "https://github.com/k1LoW/roots/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "roots";
    maintainers = with lib.maintainers; [ tnmt ];
  };
})
