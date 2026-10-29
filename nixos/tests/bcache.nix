{ pkgs, ... }:
{
  name = "bcache";
  meta.maintainers = with pkgs.lib.maintainers; [ pineapplehunter ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.emptyDiskImages = [ 4096 ];
      networking.hostId = "deadbeef";
      boot.supportedFilesystems = [ "ext4" ];
      environment.systemPackages = [ pkgs.parted ];
    };

  testScript = ''
    machine.succeed("modprobe bcache")
    machine.succeed("bcache version")
    machine.succeed("ls /dev")

    machine.succeed(
        "mkdir /tmp/mnt",
        "udevadm settle",
        "parted --script /dev/vdb mklabel gpt",
        "parted --script /dev/vdb mkpart primary 0% 50% mkpart primary 50% 100%",
        "udevadm settle",
        "bcache make -C /dev/vdb1",
        "bcache make -B /dev/vdb2",
        "udevadm settle",
        "bcache attach /dev/vdb1 /dev/vdb2",
        "bcache set-cachemode /dev/vdb2 writeback",
        "udevadm settle",
        "bcache show",
        "ls /sys/fs/bcache",
        "mkfs.ext4 /dev/bcache0",
        "mount /dev/bcache0 /tmp/mnt",
        "umount /tmp/mnt",
        "udevadm settle",
    )
  '';
}
