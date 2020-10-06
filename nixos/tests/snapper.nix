import ./make-test-python.nix ({ ... }:
{
  name = "snapper";

  machine = { pkgs, lib, ... }: {
    boot.initrd.postDeviceCommands = ''
      ${pkgs.btrfs-progs}/bin/mkfs.btrfs -f -L aux /dev/vdb
    '';

    virtualisation.emptyDiskImages = [ 4096 ];

    fileSystems = lib.mkVMOverride {
      "/home" = {
        device = "/dev/disk/by-label/aux";
        fsType = "btrfs";
      };
    };

    users.users = {
      alice = { isNormalUser = true; };
      bob = { group = "foo"; };
      charlie = {};
    };
    users.groups.foo = {};
    services.snapper.configs.home = {
      subvolume = "/home";
      allowUsers = [ "alice" ];
      allowGroups = [ "foo" ];
    };
    services.snapper.filters = "/nix";
    # users.users.createHome apparently happens before /home is mounted.
    systemd.tmpfiles.rules = [
      "d /home/alice 700 alice users"
    ];
  };

  testScript = ''
    def doas(user, cmd):
        return machine.succeed(f"sudo -u {user} sh -c '{cmd}'")


    machine.wait_for_unit("multi-user.target")
    doas("alice", "snapper -c home list")
    doas("alice", "snapper -c home create --description empty")
    doas("alice", "echo test > /home/alice/file")
    doas("bob", "snapper -c home create --description file")
    machine.fail("sudo -u charlie snapper -c home create --description denied")
    print(doas("alice", "snapper -c home status 1..2"))
    doas("alice", "snapper -c home undochange 1..2")
    machine.fail("ls /home/alice/file")
    doas("bob", "snapper -c home delete 2")
    machine.succeed("systemctl --wait start snapper-timeline.service")
    machine.succeed("systemctl --wait start snapper-cleanup.service")
  '';
})
