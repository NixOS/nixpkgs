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
  version = "0.3.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-CYIAbp6O2e8WQcaffJ6fNY0hyKduu9mfH4xkC6ZEEWU=";
  };

  cargoHash = "sha256-cKV4rrIBKPPNfBeHdZ6K8+2yU5gznPGSlFcHfKVCnNM=";

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
