{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pay-respects";
  version = "0.8.8";

  src = fetchFromCodeberg {
    owner = "iff";
    repo = "pay-respects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z7GQst70KGNTWAd3sb5eoDnMR2RAmw9RNw3qPeoLWSQ=";
  };

  cargoHash = "sha256-d3RCjCxJXb5YLai1ZqWKifbb2nLG5j1psuvAorNgFGg=";

  env = {
    _DEF_PR_AI_API_KEY = "";
    _DEF_PR_AI_URL = "";
    _DEF_PR_AI_MODEL = "";
  };

  cargoBuildFlags = [
    "-p pay-respects"
    "-p pay-respects-module-runtime-rules"
    "-p pay-respects-module-request-ai"
  ];
  cargoTestFlags = [
    "-p pay-respects"
    "-p pay-respects-module-runtime-rules"
    "-p pay-respects-module-request-ai"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal command correction, alternative to thefuck, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    changelog = "https://codeberg.org/iff/pay-respects/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
      faukah
      ALameLlama
    ];
    mainProgram = "pay-respects";
  };
})
