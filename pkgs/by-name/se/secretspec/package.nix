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
  version = "0.14.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-PlI2+cQbP/CfilYX2fJnQv8yw4euxvqYT0XqlYsU0QI=";
  };

  cargoHash = "sha256-UfeVqZaH04Ucu+FgXX2bqgqiHJNpN3OIN0lKhWFn1j0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
