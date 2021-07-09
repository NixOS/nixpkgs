{ rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "make-initrd-ng";
  version = "0.1.0";

  src = ./make-initrd-ng;

  cargoSha256 = "0vx7whn47372mg19i3vbf7ag5g0ylifx8rin2hcy81fyhmms16h6";
}
