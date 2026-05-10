{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pdf-oxide";
  version = "0.3.38";

  src = fetchFromGitHub {
    owner = "yfedoseev";
    repo = "pdf_oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kvV8SzW+2vQ86o/c9vV71O9quqQ2LVvBBvTdTwAG5wY=";
  };

  cargoHash = "sha256-Z5nNxCrf2QEUA5XCXp5aG59UnznvdS9jjQb57R8gxHs=";
  __structuredAttrs = true;

  cargoBuildFlags = [
    "--package=pdf_oxide_cli"
    "--package=pdf_oxide_mcp"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    python-bindings = python3Packages.pdf-oxide;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fastest PDF library for text extraction, image extraction, and markdown conversion";
    homepage = "https://github.com/yfedoseev/pdf_oxide";
    changelog = "https://github.com/yfedoseev/pdf_oxide/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "pdf-oxide";
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
