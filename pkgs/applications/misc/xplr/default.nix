{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0ca6r0xkcdg1ha0n79kzxqh2ks5q3l3hgylqqy62vk51c6yrjx9x";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1c29dakcff130fvavgq2kpy2ncpgxkil2mi14q2m9jpsrvhqcdvk";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
