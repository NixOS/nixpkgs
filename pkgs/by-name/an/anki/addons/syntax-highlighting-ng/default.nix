{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "syntax-highlighting-ng";
  version = "0.0.7";
  src = fetchFromGitHub {
    owner = "cav71";
    repo = "syntax-highlighting-ng";
    sparseCheckout = [ "src/syntax_highlighting_ng" ];
    tag = finalAttrs.version;
    hash = "sha256-kNZBNf1O6CDYMilvfITCM0pC4OZSP0/rKReBnRYwUUw=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/syntax_highlighting_ng";

  patchFlags = [ "-p3" ];
  patches = [ ./0001-Change-language.patch ];

  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Allows you to insert syntax-highlighted code snippets in Anki flashcards.
    '';
    homepage = "https://github.com/cav71/syntax-highlighting-ng";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dastarruer ];
  };
})
