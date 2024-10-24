{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "asciinema-scenario";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fnX5CIYLdFqi04PQPVIAYDGn+xXi016l8pPcIrYIhmQ=";
  };

  cargoHash = "sha256-8I3mPSJ5aXvQ88nh0SWyuTq9JSTktS2lQPrXlcvD66c=";

  meta = {
    homepage = "https://github.com/garbas/asciinema-scenario/";
    description = "Create asciinema videos from a text file";
    license = with lib.licenses; [ mit ];
    mainProgram = "asciinema-scenario";
    maintainers = with lib.maintainers; [ garbas ];
  };
}
