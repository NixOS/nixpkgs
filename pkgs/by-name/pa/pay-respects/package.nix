{
  lib,
  fetchFromCodeberg,
  installShellFiles,
  rustPlatform,
  versionCheckHook,
  withRuntimeRules ? true,
  withRequestAi ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pay-respects";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "iff";
    repo = "pay-respects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bFPYpAl1wf+0wFLdcl5aQOTyLxgUV8y6LJdfO/37wns=";
  };

  cargoHash = "sha256-HiZci2m+0qzFbp4HN+WwxohJfSHWo2xSw5N35y7aWso=";

  env = {
    _DEF_PR_AI_API_KEY = "";
    _DEF_PR_AI_URL = "";
    _DEF_PR_AI_MODEL = "";
  };

  cargoBuildFlags = [
    "--package=pay-respects"
  ]
  ++ lib.optional withRuntimeRules "--package=pay-respects-module-runtime-rules"
  ++ lib.optional withRequestAi "--package=pay-respects-module-request-ai";
  cargoTestFlags = [
    "--package=pay-respects"
  ]
  ++ lib.optional withRuntimeRules "--package=pay-respects-module-runtime-rules"
  ++ lib.optional withRequestAi "--package=pay-respects-module-request-ai";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/*
  '';

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
