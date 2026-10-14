{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genemichaels";
  version = "0.13.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-7+Hb3rvfdX3CaTS3nz9iaCzQBPqNJ4Y7WeC+twkqGzk=";
  };

  cargoHash = "sha256-OiDSRcmbt/Ns7moswJQcvprtIsV1VlOeV9MUeRnEIYY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
})
