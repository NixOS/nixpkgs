{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "clini";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+HnoYFRG7GGef5lV4CUsUzqPzFUzXDajprLu25SCMQo=";
  };

  cargoHash = "sha256-N18/pCOdwcYA3Uu6+/HAdeqf2xXQcZoaWhOEPMncDKM=";

  meta = with lib; {
    description = "Simple tool to do basic modification of ini files";
    homepage = "https://github.com/domgreen/clini";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
    mainProgram = "clini";
  };
}
