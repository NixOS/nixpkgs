{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pay-respects";
  version = "0.8.5";

  src = fetchFromCodeberg {
    owner = "iff";
    repo = "pay-respects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rI4cikbZ+J6SSs5l2WroM6862yDe8IFDqpmAV4Od5ng=";
  };

  cargoHash = "sha256-IQMB5bYvP/1u6FItZ34GYkMBe1fVao5CK2OPGaikIbk=";

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
