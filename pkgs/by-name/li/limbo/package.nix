{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "limbo";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "limbo";
    tag = "v${version}";
    hash = "sha256-cUGakjq6PFUKSMPKGL1CcYUjDMzdTUWUqMs0J8ZNaeQ=";
  };

  cargoHash = "sha256-pXMfAMD8ThMQvYRLTYuPimPoN42OXOL8Li0LsoQ/13A=";

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
    changelog = "https://github.com/tursodatabase/limbo/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "limbo";
  };
}
