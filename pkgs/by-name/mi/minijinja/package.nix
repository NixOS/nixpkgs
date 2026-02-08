{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minijinja";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = finalAttrs.version;
    hash = "sha256-b9Qmst+TXGGTx1k/TnDs4m1nL8aTgNYRCreNLXHCd3I=";
  };

  cargoHash = "sha256-Mpu4Cg3CPvTLAHUnv5pfV77c0aGPyfAeFuhM4iu6Em0=";

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
