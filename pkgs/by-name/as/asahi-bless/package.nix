{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-bless";
  version = "0.4.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-JU9NfBrOqZaMqaohUc+WsNWZwQVtvDSXY94d0dSFie4=";
  };

  cargoHash = "sha256-jniE+vafrc5k7xCsTHod/9oZQKro5Qm2oPXveie47cc=";
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
