{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genemichaels";
  version = "0.12.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-tAsEpEU/MpHymO/hIi3dKBoMwTQ561SI44jBTKHLfSM=";
  };

  cargoHash = "sha256-ryx/qoAJI8XchD55+n7vwRHErIEn9pgbvuUv0hGCLfg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
})
