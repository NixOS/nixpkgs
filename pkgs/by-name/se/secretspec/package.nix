{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.8.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-AslpydAYkbpgJwrqxhywfMSyR2ztMdn7Tac4rea2TiM=";
  };

  cargoHash = "sha256-wNAw/ve8xydZHrqeamsIweNF+0w5bpG+mQfO77i92gc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
