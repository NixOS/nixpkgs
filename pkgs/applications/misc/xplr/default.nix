{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "16w1lkc13qaq9zqpyfkpalcsa2050v24klvpghvfxwrriixhl34f";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1xlmycf15j9igraw9s3qh2br46vyhlp128syh57zlssizqbgks16";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
