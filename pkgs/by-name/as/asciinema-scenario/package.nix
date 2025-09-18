{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "asciinema-scenario";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fnX5CIYLdFqi04PQPVIAYDGn+xXi016l8pPcIrYIhmQ=";
  };

  cargoHash = "sha256-D9CSw05OFaWvBzGSEQmH8ao6gY/0OhQQ5gFkL1TVeO4=";

  meta = with lib; {
    description = "Create asciinema videos from a text file";
    homepage = "https://github.com/garbas/asciinema-scenario/";
    maintainers = with maintainers; [ garbas ];
    license = with licenses; [ mit ];
    mainProgram = "asciinema-scenario";
  };
}
