{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "santoshxshrestha";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zwlbWxvdtZJuz7gFdgmny6s1FsoxoBXkP4s7vF77oEo=";
  };

  cargoHash = "sha256-9XD8HbgnXhGsg1iZ/zYlk5080AhKqb8JxKKx5bxFE8M=";

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
