{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-nvram";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bFUFjHVTYj0eUmhijraOdeCvAt2UGX8+yyvooYN1Uo0=";
  };

  cargoHash = "sha256-WhySIQew8xxdwXLWkpvTYQZFiqCEPjEAjr7NVxfjDkU=";
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
