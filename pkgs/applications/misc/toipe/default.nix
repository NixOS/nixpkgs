{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "toipe";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-aunejitHVNIB/zIDgX3mlA1FzG7wIxlDCFdUvtuzQnc=";
  };

  cargoSha256 = "sha256-Nabc2lPpsUCcWEJzL6U84UoIJ5PCtYKVyLRhjhiqhpE=";

  meta = with lib; {
    description = "Trusty terminal typing tester";
    homepage = "https://github.com/Samyak2/toipe";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier samyak ];
  };
}
