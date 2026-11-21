{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-nvram";
  version = "0.2.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-qxjKCq8flKKRFd79LyoSNI1nMWeBDpFE0oVQOPDM3zE=";
  };

  cargoHash = "sha256-et7ZInot92GJobJu3motJK4QTDpvirQ2LWfJrPwuUXw=";
  cargoDepsName = finalAttrs.pname;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to read and write nvram variables on ARM Macs";
    homepage = "https://crates.io/crates/asahi-nvram";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-nvram";
    platforms = lib.platforms.linux;
  };
})
