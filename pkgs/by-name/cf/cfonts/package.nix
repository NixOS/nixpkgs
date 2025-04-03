{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-W5hN+b4R50tNfYb3WrM0z5Etm6ixa11pZWnzGC9bjSs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MXUUvk7R1JdjNlZ7h3ymUAPOT/A0I8TOW3saBB4C94o=";

  meta = with lib; {
    homepage = "https://github.com/dominikwilkowski/cfonts";
    description = "A silly little command line tool for sexy ANSI fonts in the console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leifhelm ];
    mainProgram = "cfonts";
  };
}
