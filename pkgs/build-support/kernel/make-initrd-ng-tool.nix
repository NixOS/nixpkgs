{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "make-initrd-ng";
  version = "0.1.0";

  src = ./make-initrd-ng;
  cargoLock.lockFile = ./make-initrd-ng/Cargo.lock;
}
