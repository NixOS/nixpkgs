import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "swap-partition";

    nodes.machine =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        virtualisation.useDefaultFilesystems = false;

        virtualisation.rootDevice = "/dev/vda1";

        boot.initrd.postDeviceCommands = ''
          if ! test -b /dev/vda1; then
            ${pkgs.parted}/bin/parted --script /dev/vda -- mklabel msdos
            ${pkgs.parted}/bin/parted --script /dev/vda -- mkpart primary 1MiB -250MiB
            ${pkgs.parted}/bin/parted --script /dev/vda -- mkpart primary -250MiB 100%
            sync
          fi

          FSTYPE=$(blkid -o value -s TYPE /dev/vda1 || true)
          if test -z "$FSTYPE"; then
            ${pkgs.e2fsprogs}/bin/mke2fs -t ext4 -L root /dev/vda1
            ${pkgs.util-linux}/bin/mkswap --label swap /dev/vda2
          fi
        '';

        virtualisation.fileSystems = {
          "/" = {
            device = "/dev/disk/by-label/root";
            fsType = "ext4";
          };
        };

        swapDevices = [
          {
            device = "/dev/disk/by-label/swap";
          }
        ];
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      with subtest("Swap is active"):
        # Doesn't matter if the numbers reported by `free` are slightly off due to unit conversions.
        machine.succeed("free -h | grep -E 'Swap:\s+2[45][0-9]Mi'")
    '';
  }
)
