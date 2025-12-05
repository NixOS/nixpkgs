{ pkgs, ... }:
{
  name = "bcachefs";
  meta = {
    inherit (pkgs.bcachefs-tools.meta) maintainers;
  };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.emptyDiskImages = [ 4096 ];
      networking.hostId = "deadbeef";
      boot.supportedFilesystems = [ "bcachefs" ];
      environment.systemPackages = with pkgs; [
        parted
        keyutils
      ];
    };

  testScript = ''
    machine.succeed("modprobe bcachefs")
    machine.succeed("bcachefs version")
    machine.succeed("ls /dev")

    machine.succeed(
        "mkdir /tmp/mnt",
        "udevadm settle",
        "parted --script /dev/vdb mklabel msdos",
        "parted --script /dev/vdb -- mkpart primary 1024M 50% mkpart primary 50% -1s",
        "udevadm settle",
        "echo password | bcachefs format --encrypted --metadata_replicas 2 --label vtest /dev/vdb1 /dev/vdb2",
        "echo password | bcachefs unlock -k session /dev/vdb1",
        "echo password | mount -t bcachefs /dev/vdb1:/dev/vdb2 /tmp/mnt",
        "udevadm settle",
        "bcachefs fs usage /tmp/mnt",
        "umount /tmp/mnt",
        "udevadm settle",
    )
  '';
}
