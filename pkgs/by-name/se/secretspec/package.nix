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
  version = "0.12.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-gPavr9V/mtr7mfdmgaVkE6GwIfal44JUOPR/SW1ZPqY=";
  };

  cargoHash = "sha256-ZO+vwclanqZ8z8mXTP3ytwMqsKauMceR/soPC3vXNmo=";

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
