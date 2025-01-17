{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "limbo";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "limbo";
    tag = "v${version}";
    hash = "sha256-Lmtvn7hWdrqumtTpiYK0sTsESeKo4Mfao32K0DfHmrc=";
  };

  cargoHash = "sha256-hOKTN41yqMPh/Zo8jVRiOSL331py9QRzLhkTL2Jz0yI=";

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
    changelog = "https://github.com/tursodatabase/limbo/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "limbo";
  };
}
