{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1cyybqb91n91h6nig7rxxxw9c7krz80jdfl25bdr7mlbzymssn0q";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1bj1rgsmkbby4ma325fhpb911bwabhd5bihyv9j0dfvgm1ffdm8a";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
