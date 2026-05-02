{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swaytreesave";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fabienjuif";
    repo = "swaytreesave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aAJBbauOiFERABF13hMhxyvRBzcx5c1F+vbm/U+JS8o=";
  };

  outputs = [
    "out"
  ];

  cargoHash = "sha256-5nI7YJyCu7kZTa+Gsp0LCQXNjwVhUqOAxLC7XGtfKVk=";

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
