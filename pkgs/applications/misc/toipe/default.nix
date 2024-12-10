{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "toipe";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-L4JemOxpynGYsA8FgHnMv/hrogLSRaaiIzDjxzZDqjM=";
  };

  cargoHash = "sha256-ShJ7dbd3oNo3qZJ5+ut+NfLF9j8kPPZy9yC2zl/s56k=";

  meta = with lib; {
    description = "Trusty terminal typing tester";
    homepage = "https://github.com/Samyak2/toipe";
    license = licenses.mit;
    maintainers = with maintainers; [
      loicreynier
      samyak
    ];
  };
}
