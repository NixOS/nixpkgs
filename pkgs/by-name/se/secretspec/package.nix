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
  version = "0.7.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ik4ieQifB5MFvyr6cmcwvcyr3HyUB5aHpVIhnpVB1i8=";
  };

  cargoHash = "sha256-3xaJySTsGPjU8sDL7j0biEdpcrNuOspdf41iHH6BE4o=";

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
