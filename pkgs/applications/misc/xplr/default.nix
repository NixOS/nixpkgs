{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1aanw0l8b4ak0kikkixmb817qw48ypviq9dxdivzwc29rjvgp152";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "16iaj1pqvqwi0rq4k3lmqwd8skbjf55133ri69hj26gz88k4q43w";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
