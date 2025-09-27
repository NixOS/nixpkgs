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
  version = "0.3.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-vbGUnYLL8U9CZmMLGfBxk3+0cjZR62Ug1rsis4O4iNk=";
  };

  cargoHash = "sha256-q5d+8QsyS5eMVeuwn3AYY3Mxs5nWiYtLeAJzY7SAuuQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    teams = [ lib.teams.cachix ];
    mainProgram = "secretspec";
  };
})
