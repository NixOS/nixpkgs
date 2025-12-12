{ pkgs, ... }:
{
  name = "overlayfs";
  meta.maintainers = with pkgs.lib.maintainers; [ bachp ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.emptyDiskImages = [ 512 ];
      networking.hostId = "deadbeef";
      environment.systemPackages = with pkgs; [ parted ];
    };

  testScript = ''
    machine.succeed("ls /dev")

    machine.succeed("mkdir -p /tmp/mnt")

    # Test ext4 + overlayfs
    machine.succeed(
      'mkfs.ext4 -F -L overlay-ext4 /dev/vdb',
      'mount -t ext4 /dev/vdb /tmp/mnt',
      'mkdir -p /tmp/mnt/upper /tmp/mnt/lower /tmp/mnt/work /tmp/mnt/merged',
      # Setup some existing files
      'echo Replace > /tmp/mnt/lower/replace.txt',
      'echo Append > /tmp/mnt/lower/append.txt',
      'echo Overwrite > /tmp/mnt/lower/overwrite.txt',
      'mount -t overlay overlay -o lowerdir=/tmp/mnt/lower,upperdir=/tmp/mnt/upper,workdir=/tmp/mnt/work /tmp/mnt/merged',
      # Test new
      'echo New > /tmp/mnt/merged/new.txt',
      '[[ "$(cat /tmp/mnt/merged/new.txt)" == New ]]',
      # Test replace
      '[[ "$(cat /tmp/mnt/merged/replace.txt)" == Replace ]]',
      'echo Replaced > /tmp/mnt/merged/replace-tmp.txt',
      'mv /tmp/mnt/merged/replace-tmp.txt /tmp/mnt/merged/replace.txt',
      '[[ "$(cat /tmp/mnt/merged/replace.txt)" == Replaced ]]',
      # Overwrite
      '[[ "$(cat /tmp/mnt/merged/overwrite.txt)" == Overwrite ]]',
      'echo Overwritten > /tmp/mnt/merged/overwrite.txt',
      '[[ "$(cat /tmp/mnt/merged/overwrite.txt)" == Overwritten ]]',
      # Test append
      '[[ "$(cat /tmp/mnt/merged/append.txt)" == Append ]]',
      'echo ed >> /tmp/mnt/merged/append.txt',
      '[[ "$(cat /tmp/mnt/merged/append.txt)" == "Append\ned" ]]',
      'umount /tmp/mnt/merged',
      'umount /tmp/mnt',
      'udevadm settle',
    )
  '';
}
