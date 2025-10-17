{
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "prune-electron";
  version = "1.0.0";

  src = builtins.filterSource (path: _: (!lib.hasSuffix ".nix" path)) ./.;

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    description = "Remove extra files from Electron packages, and optionally symlink Electron files into the package.";
    mainProgram = "patch-electron";
    license = lib.licenses.blueOak100;
    maintainer = lib.maintainers.RossSmyth;
  };
}
