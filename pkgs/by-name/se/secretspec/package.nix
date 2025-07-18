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
  version = "0.2.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-6a3BerjcLn86XCakyYlMm4FUUQTc7iq/hCvZEbHnp4g=";
  };

  cargoHash = "sha256-4sKja7dED1RuiRYA2BNqvvYlJhPFiM8IzAgQVeSa9Oc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ domenkozar ];
    mainProgram = "secretspec";
  };
})
