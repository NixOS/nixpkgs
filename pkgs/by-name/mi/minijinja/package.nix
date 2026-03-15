{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minijinja";
  version = "2.17.1";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = finalAttrs.version;
    hash = "sha256-cuazG7Sm6gol6FIzcK0zvUU6EunJbetmaLiurYVeVko=";
  };

  cargoHash = "sha256-QsqixSyBeo4KAnZgnY7stdrczqRREoPN7EnLN9GMCu0=";

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
