{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-wifisync";
  version = "0.2.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-YO7Yq3S7F7WuW79MR1wrViw3tTBZi8XIsXrd4f0xCzs=";
  };

  cargoHash = "sha256-cfgsY34wFeBTy0CYwVRZN22Ndifn6ZPs2t6f8DS3S2k=";
  cargoDepsName = finalAttrs.pname;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to sync Wifi passwords with macos on ARM Macs";
    homepage = "https://crates.io/crates/asahi-wifisync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-wifisync";
    platforms = lib.platforms.linux;
  };
})
