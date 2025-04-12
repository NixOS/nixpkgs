{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ixxDlHjx5Bi6Wl/kzJ/R7d+jgTDCAti25TV1RlXRPus=";
  };

  cargoHash = "sha256-NltvO5ACf8TsE9CgC1jAXx04/T/kHSZLxXJ4zhA5DGo=";

  meta = with lib; {
    homepage = "https://github.com/dominikwilkowski/cfonts";
    description = "A silly little command line tool for sexy ANSI fonts in the console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leifhelm ];
    mainProgram = "cfonts";
  };
}
