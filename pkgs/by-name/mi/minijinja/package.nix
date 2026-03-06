{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minijinja";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = finalAttrs.version;
    hash = "sha256-Q8s9NH2Su2IL2GlZIDUUmkwnfluMjOY/ULuLoL4+lEE=";
  };

  cargoHash = "sha256-7uzSuBpRWIWmtCO81i7RXP9k8mp6tTe/lMHP5nKMX1I=";

  # The tests relies on the presence of network connection
  doCheck = false;

  cargoBuildFlags = "--bin minijinja-cli";

  meta = {
    description = "Command Line Utility to render MiniJinja/Jinja2 templates";
    homepage = "https://github.com/mitsuhiko/minijinja";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ psibi ];
    changelog = "https://github.com/mitsuhiko/minijinja/blob/${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "minijinja-cli";
  };
})
