{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-nvram";
  version = "0.2.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zfUvPHAPrYhzgeiirGuqZaWnLBH0PHsqOUy2e972bWM=";
  };

  cargoHash = "sha256-FP4qCJyzCOGaPDijp18m5K1YO+Ki9oDwblP2Vh8GsO0=";
  cargoDepsName = pname;

  meta = with lib; {
    description = "Tool to read and write nvram variables on ARM Macs";
    homepage = "https://crates.io/crates/asahi-nvram";
    license = licenses.mit;
    maintainers = with maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-nvram";
    platforms = platforms.linux;
  };
}
