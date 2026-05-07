{ ... }:
{
  name = "swap-random-encryption";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.cryptsetup ];

      virtualisation.useDefaultFilesystems = false;

      virtualisation.rootDevice = "/dev/vda1";

      boot.initrd.systemd = {
        enable = true;
        repart = {
          enable = true;
          device = "/dev/vda";
          empty = "allow";
        };
      };
      systemd.repart.partitions = {
        "00-root" = {
          Type = "linux-generic";
          Format = "ext4";
          Label = "root";
        };
        "10-swap" = {
          Type = "linux-generic";
          Label = "swap";
          SizeMinBytes = "250M";
          SizeMaxBytes = "250M";
        };
      };

      virtualisation.fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/root";
          fsType = "ext4";
        };
      };

      swapDevices = [
        {
          device = "/dev/disk/by-partlabel/swap";

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
      result = json.loads(machine.succeed("lsblk -Jo PHY-SEC,LOG-SEC /dev/mapper/dev-disk-by\\x2dpartlabel-swap"))
      block_devices = result["blockdevices"]
      if len(block_devices) != 1:
        raise Exception ("lsblk output did not report exactly one block device")

      swapDevice = block_devices[0];
      if not (swapDevice["phy-sec"] == 4096 and swapDevice["log-sec"] == 4096):
        raise Exception ("swap device does not have the sector size specified in the configuration")

    with subtest("Swap encrypt has assigned cipher and keysize"):
      import re

      results = machine.succeed("cryptsetup status dev-disk-by\\x2dpartlabel-swap").splitlines()

      cipher_pattern = re.compile(r"\s*cipher:\s+aes-xts-plain64\s*")
      if not any(cipher_pattern.fullmatch(line) for line in results):
        raise Exception ("swap device encryption does not use the cipher specified in the configuration")

      key_size_pattern = re.compile(r"\s*keysize:\s+512\s+\[?bits\]?\s*")
      if not any(key_size_pattern.fullmatch(line) for line in results):
        raise Exception ("swap device encryption does not use the key size specified in the configuration")
  '';
}
