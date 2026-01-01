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

<<<<<<< HEAD
  meta = {
    description = "Tool to select active boot partition on ARM Macs";
    homepage = "https://crates.io/crates/asahi-bless";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-bless";
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Tool to select active boot partition on ARM Macs";
    homepage = "https://crates.io/crates/asahi-bless";
    license = licenses.mit;
    maintainers = with maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-bless";
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
