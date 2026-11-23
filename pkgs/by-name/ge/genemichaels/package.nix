{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genemichaels";
  version = "0.14.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-F9IhXq8bXs7jbsTuUJT8O7N793l0TGT0ok+RO7Lwyys=";
  };

  cargoHash = "sha256-IbyeLIjHyD4NDmKEcL33VWy9l2Y88NTz5/GeacA8Big=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
})
