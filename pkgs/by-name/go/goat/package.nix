{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "goat";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "blampe";
    repo = "goat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+x+bOgNa9nOMWUMUVK816DK7f4SuoWEbRr2OZ+iSPig=";
  };

  vendorHash = "sha256-RRjEFZLbfeiFUWjGZI4HSZ8PhVj1IMlU5D4Nb1sexoQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go ASCII Tool. Render ASCII art as SVG diagrams";
    homepage = "https://github.com/blampe/goat";
    changelog = "https://github.com/blampe/goat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "goat";
    platforms = lib.platforms.unix;
  };
})
