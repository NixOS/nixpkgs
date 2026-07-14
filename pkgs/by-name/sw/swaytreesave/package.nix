{
  lib,
  versionCheckHook,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swaytreesave";
  version = "0.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fabienjuif";
    repo = "swaytreesave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CEhtO7gjuuQ58kWsQKJTDqSqqw2lF7EUsO/i8d0NIiU=";
  };

  cargoHash = "sha256-gbcVgdGvKxQioL6aQcMoajsJo2rTPDNqEhsywFPCQ0s=";

  meta = {
    description = "CLI to save and load your compositors tree/layout";
    homepage = "https://github.com/fabienjuif/swaytreesave";
    changelog = "https://github.com/fabienjuif/swaytreesave/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      uzlkav
    ];
    mainProgram = "swaytreesave";
    platforms = lib.platforms.linux;
  };
})
