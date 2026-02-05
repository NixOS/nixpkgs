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
  version = "0.6.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZbyeYol8TaQz4ljTHTIHIlQwxmi/fr/ReILIOtilfEY=";
  };

  cargoHash = "sha256-UcSHFf9afU+2gl6K7XkYNEkJvslTkEO9u7qkNOKSNxg=";

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
