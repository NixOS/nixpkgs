{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-bless";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SNaA+CEuCBwo4c54qWGs5AdkBYb9IWY1cQ0dRd/noe8=";
  };

  cargoHash = "sha256-nfSJ9RkzFAWlxlfoUKk8ZmIXDJXoSyHCGgRgMy9FDkw=";
  cargoDepsName = pname;

  meta = {
    description = "Tool to select active boot partition on ARM Macs";
    homepage = "https://crates.io/crates/asahi-bless";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-bless";
    platforms = lib.platforms.linux;
  };
}
