import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "swap-random-encryption";

    nodes.machine =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        environment.systemPackages = [ pkgs.cryptsetup ];

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
            device = "/dev/vda2";

            randomEncryption = {
              enable = true;
              cipher = "aes-xts-plain64";
              keySize = 512;
              sectorSize = 4096;
            };
          }
        ];
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      with subtest("Swap is active"):
        # Doesn't matter if the numbers reported by `free` are slightly off due to unit conversions.
        machine.succeed("free -h | grep -E 'Swap:\s+2[45][0-9]Mi'")

      with subtest("Swap device has 4k sector size"):
        import json
        result = json.loads(machine.succeed("lsblk -Jo PHY-SEC,LOG-SEC /dev/mapper/dev-vda2"))
        block_devices = result["blockdevices"]
        if len(block_devices) != 1:
          raise Exception ("lsblk output did not report exactly one block device")

        swapDevice = block_devices[0];
        if not (swapDevice["phy-sec"] == 4096 and swapDevice["log-sec"] == 4096):
          raise Exception ("swap device does not have the sector size specified in the configuration")

      with subtest("Swap encrypt has assigned cipher and keysize"):
        import re

        results = machine.succeed("cryptsetup status dev-vda2").splitlines()

        cipher_pattern = re.compile(r"\s*cipher:\s+aes-xts-plain64\s*")
        if not any(cipher_pattern.fullmatch(line) for line in results):
          raise Exception ("swap device encryption does not use the cipher specified in the configuration")

        key_size_pattern = re.compile(r"\s*keysize:\s+512\s+bits\s*")
        if not any(key_size_pattern.fullmatch(line) for line in results):
          raise Exception ("swap device encryption does not use the key size specified in the configuration")
    '';
  }
)
