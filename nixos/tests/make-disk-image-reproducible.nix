# Builds the same reproducible disk image twice, as two separate derivations,
# and checks that the two images are bit-for-bit identical and that their
# filesystems are consistent.
#
# This is not a VM test: the image builds run their own build VM, and the
# check only compares files. To check a single image instead, build it and
# then rebuild it with `nix-build --check` (or `nix build --rebuild`).
{
  lib,
  pkgs,
  runCommand,
  dosfstools,
  e2fsprogs,
  qemu-utils,
  util-linux,
}:

let
  config =
    (import ../lib/eval-config.nix {
      system = null;
      modules = [
        ../modules/profiles/qemu-guest.nix
        {
          fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
          };
          fileSystems."/boot" = {
            device = "/dev/disk/by-label/ESP";
            fsType = "vfat";
          };
          boot.loader.grub = {
            efiSupport = true;
            efiInstallAsRemovable = true;
            device = "nodev";
          };
          documentation.enable = false;
          system.stateVersion = lib.trivial.release;
          nixpkgs.pkgs = pkgs;
        }
      ];
    }).config;

  # The name makes the two builds separate derivations. It does not reach the
  # image itself.
  makeImage =
    name:
    import ../lib/make-disk-image.nix {
      inherit
        pkgs
        lib
        config
        name
        ;
      # A dynamic VHD, so that the footer and its copy are covered too.
      format = "vpc";
      partitionTableType = "efi";
      reproducible = true;
      copyChannel = false;
    };

  first = makeImage "reproducible-image-first";
  second = makeImage "reproducible-image-second";
in
runCommand "make-disk-image-reproducible"
  {
    nativeBuildInputs = [
      dosfstools
      e2fsprogs
      qemu-utils
      util-linux
    ];
    meta.platforms = lib.platforms.linux;
  }
  ''
    if ! cmp ${first}/nixos.vhd ${second}/nixos.vhd; then
      echo "Two builds of the same image differ in $(cmp -l ${first}/nixos.vhd ${second}/nixos.vhd | wc -l) bytes." >&2
      echo "See \"How to run determinism analysis on results?\" in nixos/lib/make-disk-image.nix." >&2
      exit 1
    fi

    qemu-img convert -f vpc -O raw ${first}/nixos.vhd image.raw
    extract() {
      eval "$(partx image.raw -o START,SECTORS --nr "$1" --pairs)"
      dd if=image.raw of="$2" bs=512 skip="$START" count="$SECTORS" status=none
    }
    extract 1 esp.img
    extract 2 root.img
    fsck.vfat -n esp.img
    e2fsck -fn root.img

    touch $out
  ''
