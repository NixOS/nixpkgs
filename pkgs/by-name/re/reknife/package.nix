{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reknife";
  version = "1.8.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bl4ckr0ss3";
    repo = "knife";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uHYSNKe8CsOBJUO55dNzFJ986h3SdYN/a7K9XOnzfcY=";
  };

  cargoHash = "sha256-NbIv7WtWvyeZ0ZwFGPvS57AgBE+7z0mdFu4+NK/+lQE=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for reverse engineering binaries";
    homepage = "https://github.com/bl4ckr0ss3/knife";
    changelog = "https://github.com/bl4ckr0ss3/knife/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "knife";
  };
})
