{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1rw345zpa1h2gcazx8f8i3dwagabl1l7ja5pkcnzvhvq4d5hn85y";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "167dzm0pva99pyd8fmyj3zarr2xix0id21y0h4f10mz88frx3r6q";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
