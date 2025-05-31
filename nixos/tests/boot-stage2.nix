{ pkgs, ... }:
{
  name = "boot-stage2";

  nodes.machine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      virtualisation = {
        emptyDiskImages = [ 256 ];

        # Mount an ext4 as the upper layer of the Nix store.
        fileSystems = {
          "/nix/store" = lib.mkForce {
            device = "/dev/vdb"; # the above disk image
            fsType = "ext4";

            # data=journal always displays after errors=remount-ro; this is only needed because of the overlay
            # and #375257 will trigger with `errors=remount-ro` on a non-overlaid store:
            # see ordering in https://github.com/torvalds/linux/blob/v6.12/fs/ext4/super.c#L2974
            options = [
              "defaults"
              "errors=remount-ro"
              "data=journal"
            ];
          };
        };
      };

      boot = {
        initrd = {
          # Format the upper Nix store.
          postDeviceCommands = ''
            ${pkgs.e2fsprogs}/bin/mkfs.ext4 /dev/vdb
          '';

          # Overlay the RO store onto it.
          # Note that bug #375257 can be triggered without an overlay,
          # using the errors=remount-ro option (or similar) or with an overlay where any of the
          # paths ends in 'ro'. The offending mountpoint also has to be the last (top) one
          # if an option ending in 'ro' is the last in the list, so test both cases here.
          postMountCommands = ''
            mkdir -p /mnt-root/nix/store/ro /mnt-root/nix/store/rw /mnt-root/nix/store/work
            mount --bind /mnt-root/nix/.ro-store /mnt-root/nix/store/ro
            mount -t overlay overlay \
              -o lowerdir=/mnt-root/nix/store/ro,upperdir=/mnt-root/nix/store/rw,workdir=/mnt-root/nix/store/work \
              /mnt-root/nix/store
          '';

          kernelModules = [ "overlay" ];
        };

        postBootCommands = ''
          touch /etc/post-boot-ran
          mount
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("test /etc/post-boot-ran")
    machine.fail("touch /nix/store/should-not-work");
  '';

  meta.maintainers = with pkgs.lib.maintainers; [ numinit ];
}
