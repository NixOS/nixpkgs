{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1jfclwpip4xvwkvz5g0fb3v04pdnk3ddvkdll0yr7wm0g6p44xfd";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "06iwx3s7h6l9kvd17hx0ihy6zrz4jbfjmdlkyij2fs0fhvas110x";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
