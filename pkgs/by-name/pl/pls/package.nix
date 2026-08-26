{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pls";
  version = "0.0.1-beta.10";

  src = fetchFromGitHub {
    owner = "pls-rs";
    repo = "pls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j0bYikR0DoHRcArNnHsuYxdYqT9YjsH1g+T3s16UmcI=";
  };

  cargoHash = "sha256-eh0beK1UYf/Xe30wGxli6dfPKh875yTnOn7CCN2XTtI=";

  meta = {
    changelog = "https://github.com/pls-rs/pls/releases/tag/${finalAttrs.src.tag}";
    description = "Prettier and powerful ls";
    homepage = "http://pls.cli.rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
