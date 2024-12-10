{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-bless";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pgl424SqeHODsjGwNRJtVHT6sKRlYxlXl3esEKK02jc=";
  };

  cargoHash = "sha256-ilblP8nqb/eY0+9Iua298M7NQKv+IwtdliGd9ZYAVaM=";
  cargoDepsName = pname;

  meta = with lib; {
    description = "Tool to select active boot partition on ARM Macs";
    homepage = "https://crates.io/crates/asahi-bless";
    license = licenses.mit;
    maintainers = with maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-bless";
    platforms = platforms.linux;
  };
}
