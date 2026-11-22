{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reknife";
  version = "1.8.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bl4ckr0ss3";
    repo = "knife";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZGQJHjMwQHd1Hr9herM8+zM2BFflrZVz/rZFMB55cME=";
  };

  cargoHash = "sha256-36KJ51mOp7otWN9BcvCb8+XQhbfFL6MrpiRL9JDl3/w=";

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
