{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-bless";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SNaA+CEuCBwo4c54qWGs5AdkBYb9IWY1cQ0dRd/noe8=";
  };

  cargoHash = "sha256-Ou6sZ0fjsiadNcsdyiqxRwg+JIXMA4oanIgyW6NrLwI=";
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
