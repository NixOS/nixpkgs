{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-bless";
  version = "0.4.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-JBd1YPTJ2ZqcGZ+FTGR2hqXWYd+kJ/0snWrn4uEpXWg=";
  };

  cargoHash = "sha256-DN5PRUO0M0/ExIkuR+Iwk3SW1jzIaFnzvLOBuFoJ360=";
  cargoDepsName = finalAttrs.pname;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to select active boot partition on ARM Macs";
    homepage = "https://crates.io/crates/asahi-bless";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-bless";
    platforms = lib.platforms.linux;
  };
})
