{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agg";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6UenPE6mmmvliaIuGdQj/FrlmoJvmBJgfo0hW+uRaxM=";
  };

  strictDeps = true;

  cargoHash = "sha256-VpbjvrMhzS1zrcMNWBjTLda6o3ea2cwpnEDUouwyp8w=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "agg";
  };
})
