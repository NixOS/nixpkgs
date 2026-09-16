# Foreign package overlays (AUR / pacman / dnf / deb).
#
# `system.foreignPackages` is a list of derivations produced by
# `pkgs.foreignPackages` (see pkgs/build-support/foreign-packages/): each one
# is an extracted package (a filesystem overlay) whose post-install scripts
# have been run and whose store output is read-only.
#
# Wiring done here:
#   - the overlay binaries (usr/bin and bin) are merged into the system PATH,
#   - when `system.fhsCompatibility.enable` is set, every file in the overlay
#     that is not already present in the FHS rootfs is symlinked into the
#     rootfs (see nixos/modules/system/alternatives.nix, which consumes
#     `config.system.foreignPackages` for the rootfs build).
#
# This is opt-in and additive: with an empty list (the default), nothing
# changes.
{
  lib,
  config,
  pkgs,
  ...
}:

let
  fkgs = config.system.foreignPackages;

  # Merge /usr/bin and /bin of each overlay into a normal package so the
  # binaries appear on the system PATH.
  binPackages = map (p: pkgs.runCommand "foreign-${p.name}-bins" { } ''
    mkdir -p $out/bin
    ln -sfn ${p}/usr/bin/* $out/bin/ 2>/dev/null || true
    ln -sfn ${p}/bin/* $out/bin/ 2>/dev/null || true
    for l in $out/bin/*; do
      [ -L "$l" ] || rm -f "$l"
    done
  '') fkgs;
in
{
  _class = "nixos";

  options.system.foreignPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    example = lib.literalExpression ''
      [
        (pkgs.foreignPackages {
          url = "https://example.com/foo_1.0_amd64.deb";
        })
      ]
    '';
    description = ''
      Foreign package overlays (AUR / pacman / dnf / deb archives converted
      with `pkgs.foreignPackages`) to merge into the system. Their binaries
      are added to PATH; with `system.fhsCompatibility.enable` their files
      are additionally merged into the FHS rootfs.
    '';
  };

  config = lib.mkIf (fkgs != [ ]) {
    environment.systemPackages = binPackages;
  };
}