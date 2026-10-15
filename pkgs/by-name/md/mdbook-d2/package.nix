{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-d2";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TGNH89LeFsBTeL92ZFesHLxFzdAweSg3j0SXwvUzqig=";
  };

  cargoHash = "sha256-A+viDBoK/L5yKnEfO0Vrh223AI1KJbuQIdRatpmz1dw=";
  doCheck = false;

  meta = {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
