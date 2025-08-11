{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "santoshxshrestha";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v+QsSPknUAFk+GC8D0wtA8VTcCWeb8DX6inL6WNl8gQ=";
  };

  cargoHash = "sha256-4Xvi5DxlqxfwnIa00Dr7tRzYa8/52BH/SODiNenlFDg=";

  updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple CLI tool to live-preview Markdown files in your browser";
    homepage = "https://github.com/santoshxshrestha/mdwatch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "mdwatch";
  };
})
