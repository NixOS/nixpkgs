{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "detect";
  version = "0.3.0";

  # if we use fetchCrate the tests fail, because the fixtures weren't included in the published crate
  src = fetchFromGitHub {
    owner = "inanna-malick";
    repo = "detect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8aLvHBt4HPpVb4676l7V1bZ3YJQ5W3/LZZU5oRCk+K4=";
  };

  cargoHash = "sha256-hAjFnpOgb31yQWVFFNGP0E8kT6G6OhB90kfkJsQtaWg=";

  meta = {
    description = "Expression-based file search combining name, content, metadata, and structured data predicates";
    homepage = "https://github.com/inanna-malick/detect/";
    changelog = "https://github.com/inanna-malick/detect/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ lilyball ];
    mainProgram = "detect";
  };
})
