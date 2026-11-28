{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rura";
  version = "1.14.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tlipinski";
    repo = "rura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TL4YY/5Z74PC9P4dU44xuC2KLAddk3e/Z9xX9iAdTo0=";
  };

  cargoHash = "sha256-XnDQpGwEF6vg0hC06bh6zuKBKsMgPBY2CIgVwvs4mP0=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive TUI scratchpad for building shell pipelines";
    homepage = "https://github.com/tlipinski/rura";
    changelog = "https://github.com/tlipinski/rura/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "rura";
  };
})
