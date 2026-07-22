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
  version = "0.12.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Oj1CaiL0uGhlyrJK+xfKLH3f9wYDQTIiDTxop3BTnNs=";
  };

  cargoHash = "sha256-5VKiagAQnUIL1i36hQ+zUgScfBkg0uwKG3FMQdrlIq4=";

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
