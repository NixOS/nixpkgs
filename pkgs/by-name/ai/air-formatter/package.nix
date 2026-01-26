{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "air-formatter";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "air";
    tag = finalAttrs.version;
    hash = "sha256-+AsKwigWikAv8NOaIYVvrH3Pub7Q9qV5YOp2jYU2GkE=";
  };

  cargoHash = "sha256-ndd4ps2X/+a62p3dlv8jxhr2bbBG88rytI1XBVntk+g=";

  useNextest = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  cargoBuildFlags = [ "-p air" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast R code formatter";
    homepage = "https://posit-dev.github.io/air";
    changelog = "https://github.com/posit-dev/air/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
    mainProgram = "air";
  };
})
