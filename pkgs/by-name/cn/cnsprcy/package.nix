{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cnsprcy";
  version = "0.3.2";

  src = fetchFromSourcehut {
    owner = "~xaos";
    repo = "cnsprcy";
    rev = "cnspr/v${finalAttrs.version}";
    hash = "sha256-wwsemwN87YsNRLkr0UNbzSLF2WDaKY6IFXew64g4QoU=";
  };

  sourceRoot = "${finalAttrs.src.name}/v${finalAttrs.version}";

  cargoHash = "sha256-8hNuF5tD1PwdIJB0q3wxDOGDcppo0ac+zol3AHWGv0s=";

  passthru.updateScript = ./update.sh;

  RUSTC_BOOTSTRAP = true;
  buildInputs = [ sqlite ];

  meta = {
    description = "End to end encrypted connections between trusted devices";
    homepage = "https://git.sr.ht/~xaos/cnsprcy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      supinie
      oluchitheanalyst
    ];
    teams = [ lib.teams.ngi ];
    mainProgram = "cnspr";
    platforms = lib.platforms.linux;
  };
})
