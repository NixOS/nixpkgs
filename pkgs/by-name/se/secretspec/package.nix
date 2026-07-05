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
  version = "0.13.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-pOlfDWFjhndp+Wq/UzL/bYcgQHkWTrnuUd7w2WiqJog=";
  };

  cargoHash = "sha256-ITv4MGpg11mnp5YbfUd/xd7dLl2ll21ybGCyTO4UAx4=";

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
