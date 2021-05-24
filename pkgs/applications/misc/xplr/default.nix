{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.11.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "04bczvs0n1mpfrqd9fxjy9hmiddzdsbh8pav7mb56wqxxdaarwni";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1lpnkyvsyz4j2wikjvrh1v5mnzx4sv3m9brxp8km5mrryhiqp22s";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
