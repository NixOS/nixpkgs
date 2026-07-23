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
  version = "0.10.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-aFfMgYwRLDSMRAAsh9UpTzKREKgGONycTV71Fyf1fCY=";
  };

  cargoHash = "sha256-I91sGPtCZxfhGYgeQDKZcs1yfSKiqlIcnC5wD3LB0BY=";

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
