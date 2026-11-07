{
  rustPlatform,
  lib,
  callPackage,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "make-initrd-ng";
  version = "0.1.0";

  src = ./make-initrd-ng;
  cargoLock.lockFile = ./make-initrd-ng/Cargo.lock;

  passthru = {
    updateScript = ./make-initrd-ng/update.sh;
    tests.dlopen-alternatives = callPackage ./make-initrd-ng-test.nix {
      makeInitrdNGTool = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Tool for copying binaries and their dependencies";
    mainProgram = "make-initrd-ng";
    maintainers = with lib.maintainers; [
      elvishjerricco
      k900
    ];
    license = lib.licenses.mit;
  };
})
