{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genemichaels";
  version = "0.9.6";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-H/IqREaLvfKQZGOioIJ7t3GdNzTTiE3fYlMOaxXASr4=";
  };

  cargoHash = "sha256-16axK0kQnkr99x13OvAqhCQz7hT1rRMZIRW4MgNOo40=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
})
