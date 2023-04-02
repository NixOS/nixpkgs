# This tests for race conditions creating home directories mounted
# in a few different ways

let
  alice = {
    isNormalUser = true;
    name = "alice";
    group = "users";
    home = "/home/alice";
    homeMode = "755";
  };

  bob = {
    isNormalUser = true;
    name = "bob";
    group = "users";
    home = "${mounts.auto}/bob";
    homeMode = "700";
  };

  cara = {
    isNormalUser = true;
    name = "cara";
    group = "users";
    home = "${mounts.nfs}/cara";
    homeMode = "755";
  };

  mounts = { nfs = "/mnt/nfs"; auto = "/mnt/auto"; };
in
import ./make-test-python.nix ({ lib, ... }: {
  name = "user-home-mounts";

  meta.maintainers = [ lib.maintainers.jsoo1 ];

  nodes = {
    machine = {
      users.users = { inherit alice bob cara; };

      systemd.automounts = [{ where = mounts.auto; }];

      virtualisation.fileSystems."${mounts.nfs}" = {
        device = "nfs:/export";
        fsType = "nfs";
      };
    };

    nfs = {
      networking.firewall.allowedTCPPorts = [ 2049 ];

      virtualisation.fileSystems."/export" = {
        device = "/home";
        options = [ "bind" ];
      };

      services.nfs.server = {
        enable = true;
        exports = ''
          /export machine(rw,no_root_squash,sync)
        '';
      };
    };
  };

  testScript = ''
    nfs.wait_for_unit("nfs-mountd.service")
    machine.wait_for_unit("remote-fs.target")
    machine.wait_for_unit("multi-user.target")

    with subtest("local"):
        alice_out = machine.succeed("stat -c '%U %G %a' ${alice.home}")
        assert alice_out.strip() == "${alice.name} ${alice.group} ${alice.homeMode}", f"alice's home failed, got: {alice_out}"

    with subtest("automount"):
        machine.succeed("ls ${mounts.auto}")
        bob_out = machine.succeed("stat -c '%U %G %a' ${bob.home}")
        assert bob_out.strip() == "${bob.name} ${bob.group} ${bob.homeMode}", f"bob's home failed, got: {bob_out}"

    with subtest("nfs is not supported"):
        # just make sure nfs is working
        machine.succeed("mkdir ${mounts.nfs}/foo")
        nfs.succeed("stat /export/foo")

        # nfs mounts are expected to overwrite tmpfiles.d homes
        machine.fail("stat -c '%U %G %a' ${cara.home}")
  '';
})
