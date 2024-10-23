{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "hickory-util";
  version = "0.24.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cDFKsD/6LmMrMZ5B2eC7ACmmh0Sxfnd3Y2KRbZ4e0yY=";
  };

  cargoHash = "sha256-8XDl+05cFcN+oZZMGUHS53QawKm+DiKPTIkU/HmP9dY=";

  meta = {
    description = "CLI utilities for Hickory DNS client";
    homepage = "https://github.com/hickory-dns/hickory-dns/";
    maintainers = with lib.maintainers; [ nartsiss ];
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
}
