{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "00kgxc4pn07p335dl3d53shiyw4f4anw64qc8axz9nspdq734nj5";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1wmc4frjllj8dgcg4yw4cigm4mhq807pmp3l3ysi70q490g24gwh";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
