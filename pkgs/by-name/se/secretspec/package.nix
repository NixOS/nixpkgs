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
  version = "0.8.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-xlri/PeTUVcubwUUi2mF6eaBIzwANKiNtTOrzm2X//g=";
  };

  cargoHash = "sha256-1l5qeFq7F37LbQZZPAmw3PyUg8jcF5SxhFAtrR81Gj4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];
  buildFeatures = [
    "vault"
    "awssm"
    "gcsm"
  ];

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
