{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0bhw690kq0agdj1421yay8jpd8p155nnq49hyj8q7d1yd3h09si9";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1j6lzwxpkpmgqznhb3xlkkrnp9mz8q8d9j5vhb566pd2dac4k5c0";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
