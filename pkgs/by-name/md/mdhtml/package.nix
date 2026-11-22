{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:

buildGoModule (finalAttrs: {
  pname = "mdhtml";
  version = "1.0";

  src = fetchFromCodeberg {
    owner = "Tomkoid";
    repo = "mdhtml";
    rev = finalAttrs.version;
    hash = "sha256-Fv5XpWA2ebqXdA+46gZQouuZ3XxH4WDj/W6xJ0ETg8E=";
  };

  vendorHash = null;

  meta = {
    description = "Really simple CLI Markdown to HTML converter with styling support";
    homepage = "https://codeberg.org/Tomkoid/mdhtml";
    license = lib.licenses.mit;
    changelog = "https://codeberg.org/Tomkoid/mdhtml/releases";
    maintainers = with lib.maintainers; [ tomkoid ];
    mainProgram = "mdhtml";
  };
})
