{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "limbo";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "limbo";
    tag = "v${version}";
    hash = "sha256-bX56aiL7Eqa3jLd1u9h6u583q0S9VZfJ+cVPB+8R1eU=";
  };

  cargoHash = "sha256-GspyWOxwAQvjNzN0yZvj3WpADR3VUO0MjSKiq9wbLOw=";

  cargoBuildFlags = [
    "-p"
    "limbo"
  ];
  cargoTestFlags = cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive SQL shell for Limbo";
    homepage = "https://github.com/tursodatabase/limbo";
    changelog = "https://github.com/tursodatabase/limbo/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "limbo";
  };
}
