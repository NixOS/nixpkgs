{
  lib,
  rustPlatform,
  btrfs-progs,
  util-linux,

  distroName ? "NixOS",
}:
let
  inherit (lib.importTOML ./Cargo.toml) package;
in
rustPlatform.buildRustPackage {
  pname = package.name;
  inherit (package) version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.lock
      ./Cargo.toml
      ./src
    ];
  };

  cargoLock.lockFile = ./Cargo.lock;

  env = {
    BLKID = lib.getExe' util-linux "blkid";
    BTRFS = lib.getExe' btrfs-progs "btrfs";
    DISTRO_NAME = distroName;
  };

  meta = {
    description = "GRUB configurator and installer for NixOS (internal use)";
    mainProgram = "install-grub";
    maintainers = with lib.maintainers; [ pluiedev ];
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
}
