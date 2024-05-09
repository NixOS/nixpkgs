{ rustPlatform, lib, makeWrapper, patchelf, glibc, binutils }:

rustPlatform.buildRustPackage {
  pname = "make-initrd-ng";
  version = "0.1.0";

  src = ./make-initrd-ng;
  cargoLock.lockFile = ./make-initrd-ng/Cargo.lock;

  passthru.updateScript = ./make-initrd-ng/update.sh;

  meta = {
    description = "Tool for copying binaries and their dependencies";
    mainProgram = "make-initrd-ng";
    maintainers = with lib.maintainers; [ das_j elvishjerricco k900 lheckemann ];
    license = lib.licenses.mit;
  };
}
