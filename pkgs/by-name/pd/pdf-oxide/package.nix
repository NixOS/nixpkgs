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
  version = "0.3.47";

  src = fetchFromGitHub {
    owner = "yfedoseev";
    repo = "pdf_oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l9AVY9HNGdO7fBjJbIenAu6UfDoMWXq9m45VeV4F/yY=";
  };

  cargoHash = "sha256-KFOEnkObbK2H2v5EqVzdQNVATwOGJK54GfLOU7J+fYM=";
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
