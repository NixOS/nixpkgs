{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

let
  features = [
    "rustls-webpki"
    "geosparql"
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxigraph";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q/wMRDTlz7xH59Mc+G+DOH0GYzE3KYPFvBZtVYVOeQI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-qk4NloQU0am8yqoViXZy9TmGvQ6RJt3otzaVugoF4mc=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildAndTestSubdir = "cli";
  buildNoDefaultFeatures = true;
  buildFeatures = features;

  # Man pages and autocompletion
  postInstall = ''
    MAN_DIR="$(find target/*/release -name man)"
    installManPage "$MAN_DIR"/*.1
    COMPLETE_DIR="$(find target/*/release -name complete)"
    installShellCompletion --bash --name oxigraph.bash "$COMPLETE_DIR/oxigraph.bash"
    installShellCompletion --fish --name oxigraph.fish "$COMPLETE_DIR/oxigraph.fish"
    installShellCompletion --zsh --name _oxigraph "$COMPLETE_DIR/_oxigraph"
  '';

  cargoCheckNoDefaultFeatures = true;
  cargoCheckFeatures = features;

  meta = {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      astro
      tnias
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "oxigraph";
  };
})
