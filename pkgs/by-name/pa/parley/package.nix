{
  lib,
  fetchFromGitea,
  buildGo127Module,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "parley";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.mills.io";
    owner = "prologic";
    repo = "parley";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DnoVNqCuhLHeU+puICZzIEYK9Tw02daFQ9VHkSo9kpQ=";
  };

  vendorHash = "sha256-siSavE8i/Rh6LfI+HXhyKsPrbfyncJCcEYJsA4KZ378=";

  subPackages = [
    "cmd/parleyd"
    "cmd/parleyctl"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Federated, decentralised chat that speaks plain IRC";
    homepage = "https://git.mills.io/prologic/parley";
    changelog = "https://git.mills.io/prologic/parley/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pinpox ];
    mainProgram = "parleyd";
  };
})
