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
    let
      # Prints the user's UID. Can't just do a shell script
      # because setuid is ignored for interpreted programs.
      uid = pkgs.writeCBin "uid" ''
        #include <unistd.h>
        #include <stdio.h>
        int main(void) {
          printf("%d\n", geteuid());
          return 0;
        }
      '';
    in
    {
      users.users.alice = {
        isNormalUser = true;
        uid = 1000;
      };

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

      environment.systemPackages = [ pkgs.xxd ];

      system.extraDependencies = [ uid ];

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

            # Be very rude and try to put suid files and/or devices into the store.
            evil=/mnt-root/nix/store/evil
            mkdir -p $evil/bin $evil/dev

            echo "making evil suid..." >&2
            cp /mnt-root/${builtins.unsafeDiscardStringContext "${uid}"}/bin/uid $evil/bin/suid
            chmod 4755 $evil/bin/suid
            [ -u $evil/bin/suid ] || exit 1

            echo "making evil devzero..." >&2
            mknod -m 666 $evil/dev/zero c 1 5
            [ -c $evil/dev/zero ] || exit 1
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

    for opt in ["ro", "nosuid", "nodev"]:
      with subtest(f"testing store mount option: {opt}"):
        machine.succeed(f'[[ "$(findmnt --direction backward --first-only --noheadings --output OPTIONS /nix/store)" =~ (^|,){opt}(,|$) ]]')

    # should still be suid
    machine.succeed('[ -u /nix/store/evil/bin/suid ]')
    # runs as alice and is not root
    machine.succeed('[ "$(sudo -u alice /nix/store/evil/bin/suid)" == 1000 ]')
    # can be remounted and runs as root
    machine.succeed('mount -o remount,suid,bind /nix/store && mount >&2')
    machine.succeed('[ "$(sudo -u alice /nix/store/evil/bin/suid)" == 0 ]')
    # double checking we can undo it
    machine.succeed('mount -o remount,nosuid,bind /nix/store && mount >&2')
    machine.succeed('[ "$(sudo -u alice /nix/store/evil/bin/suid)" == 1000 ]')

    # should still be a character device
    machine.succeed('[ -c /nix/store/evil/dev/zero ]')
    # should not work
    machine.fail('[ "$(dd if=/nix/store/evil/dev/zero bs=1 count=1 | xxd -pl1)" == 00 ]')
    # can be remounted and works
    machine.succeed('mount -o remount,dev,bind /nix/store && mount >&2')
    machine.succeed('[ "$(dd if=/nix/store/evil/dev/zero bs=1 count=1 | xxd -pl1)" == 00 ]')
    # double checking we can undo it
    machine.succeed('mount -o remount,nodev,bind /nix/store && mount >&2')
    machine.fail('[ "$(dd if=/nix/store/evil/dev/zero bs=1 count=1 | xxd -pl1)" == 00 ]')
  '';

  meta.maintainers = with pkgs.lib.maintainers; [ numinit ];
}
