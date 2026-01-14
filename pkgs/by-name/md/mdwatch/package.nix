{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "santoshxshrestha";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3iqursj/d4z24SW+7qChe5BUMLhXeJOAsT6PhQG+NMU=";
  };

  cargoHash = "sha256-7WpmvCNPOWk1F7tmB4U/EyjauFZOdkixCTO1lKTphrM=";

  updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple CLI tool to live-preview Markdown files in your browser";
    homepage = "https://github.com/santoshxshrestha/mdwatch";
    changelog = "https://github.com/santoshxshrestha/mdwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "mdwatch";
  };
})
