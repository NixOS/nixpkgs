{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-rGU9Jf+MHDs3pnuddqxLaWc8YqL+Ka7Rex+fTuU62sM=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-GwepsY7PcWjKZpJ7H4D9vtXwd2XGFgG1c+QvinMAG4Q=";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
