{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-wifisync";
  version = "0.2.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-wKd6rUUnegvl6cHODVQlllaOXuAGlmwx9gr73I/2l/c=";
  };

  cargoHash = "sha256-ZxgRxQyDID3mBpr8dhHScctk14Pm9V51Gn24d24JyVk=";
  cargoDepsName = finalAttrs.pname;

  meta = {
    description = "Tool to sync Wifi passwords with macos on ARM Macs";
    homepage = "https://crates.io/crates/asahi-wifisync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-wifisync";
    platforms = lib.platforms.linux;
  };
})
