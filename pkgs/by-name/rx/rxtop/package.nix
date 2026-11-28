{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rxtop";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Vl+rp6NiAZMGRj9miHZ4Q0ME96bYlb9a77I3xG3W8QU=";
  };

  cargoHash = "sha256-Mzye0oqSmNG/wwiDmbLG/bgt0x3W9jgnOszaFdqLeOY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal process resource manager for the terminal";
    homepage = "https://github.com/NikoPit/rxtop";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ NikoPit ];
    mainProgram = "rxtop";
  };
})
