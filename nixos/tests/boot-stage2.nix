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
        fileSystems = {
          "/nix/store".overlay.lowerdir = [ (lib.mkForce "/nix/ro") ];
          "/nix/ro" = {
            fsType = "none";
            options = [ "bind" ];
            device = "/sysroot/nix/.ro-store";
            neededForBoot = true;
          };
        };
      };

      environment.systemPackages = [ pkgs.xxd ];

      system.extraDependencies = [ uid ];

      boot = {
        initrd = {
          # Overlay the RO store onto it.
          # Note that bug #375257 can be triggered without an overlay,
          # using the errors=remount-ro option (or similar) or with an overlay where any of the
          # paths ends in 'ro'. The offending mountpoint also has to be the last (top) one
          # if an option ending in 'ro' is the last in the list, so test both cases here.
          systemd.services.evil-files = {
            requiredBy = [ "initrd.target" ];
            after = [ "initrd-fs.target" ];
            serviceConfig.Type = "oneshot";
            script = ''
              # Be very rude and try to put suid files and/or devices into the store.
              evil=/sysroot/nix/store/evil
              mkdir -p $evil/bin $evil/dev

              echo "making evil suid..." >&2
              cp /sysroot/${builtins.unsafeDiscardStringContext "${uid}"}/bin/uid $evil/bin/suid
              chmod 4755 $evil/bin/suid
              [ -u $evil/bin/suid ] || exit 1

              echo "making evil devzero..." >&2
              mknod -m 666 $evil/dev/zero c 1 5
              [ -c $evil/dev/zero ] || exit 1
            '';
          };
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
