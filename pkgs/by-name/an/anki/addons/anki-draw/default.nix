{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-draw";
  version = "1.2.2";
  src = fetchFromGitHub {
    owner = "Rytisgit";
    repo = "Anki-StylusDraw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-snLYfujXXRake0QVvEUv5nm9VSFY9CUheX1AdZpISds=";
  };
  sourceRoot = "${finalAttrs.src.name}/AnkiDraw";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Draw and write using mouse and stylus with pressure support";
    homepage = "https://github.com/Rytisgit/Anki-StylusDraw";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ euank ];
  };
})
