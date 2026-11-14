{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fontc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "fontc";
    tag = "fontc-v${finalAttrs.version}";
    hash = "sha256-cFvs5ArYiL8lS2ivqs0XF7wga/U8WufXhkUp0i16CYM=";
  };
  buildAndTestSubdir = "fontc";

  cargoHash = "sha256-xC+uQmVR9sDhmQXOX7DMFCif7KjSFpKGpXq/koTOHvw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wherein we pursue oxidizing fontmake";
    homepage = "https://github.com/googlefonts/fontc";
    changelog = "https://github.com/googlefonts/fontc/releases/tag/fontc-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shiphan ];
    mainProgram = "fontc";
  };
})
