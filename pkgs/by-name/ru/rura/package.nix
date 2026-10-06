{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rura";
  version = "1.13.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tlipinski";
    repo = "rura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4uq2lD0fMGpWTFlhtIU4Q73Hg/gyg0ClIa3UOJgSps4=";
  };

  cargoHash = "sha256-1ZzaJVjDoDwtq4koabwq1/p2TRUBdob7IvG6UBqrZzk=";

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
