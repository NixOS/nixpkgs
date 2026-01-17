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
  version = "0.6.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-OBIIKoF0WDkLQDVmEQJ8+EyVhFCq1dESgIbAVfNuyBU=";
  };

  cargoHash = "sha256-y6ayj6FcqZI9VR6bXIKdDKrJTFDxF49ZFXXPnWLG6tQ=";

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
