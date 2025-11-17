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

  cargoHash = "sha256-NW/puo/Xoum7DjSQjBgilQcKbY3mAfVgXxUK6+1H1JI=";
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
