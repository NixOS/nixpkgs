{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "limbo";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "limbo";
    tag = "v${version}";
    hash = "sha256-t3bIW+HuuZzj3NOw2lnTZw9qxj7lGWtR8RbZF0rVbQ4=";
  };

  cargoHash = "sha256-DDUl/jojhDmSQY7iI/Dn+Lg4eNuNhj8jyakPtgg4d2k=";

  cargoBuildFlags = [
    "-p"
    "limbo"
  ];
  cargoTestFlags = cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive SQL shell for Limbo";
    homepage = "https://github.com/tursodatabase/limbo";
    changelog = "https://github.com/tursodatabase/limbo/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "limbo";
  };
}
