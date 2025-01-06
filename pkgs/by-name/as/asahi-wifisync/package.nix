{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-wifisync";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wKd6rUUnegvl6cHODVQlllaOXuAGlmwx9gr73I/2l/c=";
  };

  cargoHash = "sha256-UF1T0uAFO/ydTWigYXOP9Ju1qgV1oBmJuXSq4faSzJM=";
  cargoDepsName = pname;

  meta = {
    description = "Tool to sync Wifi passwords with macos on ARM Macs";
    homepage = "https://crates.io/crates/asahi-wifisync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-wifisync";
    platforms = lib.platforms.linux;
  };
}
