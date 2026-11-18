{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paranoia";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "altumptic";
    repo = "paranoia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-roGCN4hIjoRHfAXop8b4twAfmkOnuot0OhsAN87YcsE=";
  };

  cargoHash = "sha256-mnP7P6l+AE+icL3HMgXiW24n9tT/IXt+J4OLs809+3w=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reverse engineering tool";
    homepage = "https://github.com/altumptic/paranoia";
    changelog = "https://github.com/altumptic/paranoia/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "paranoia";
  };
})
