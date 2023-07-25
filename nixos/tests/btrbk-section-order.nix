# This tests validates the order of generated sections that may contain
# other sections.
# When a `volume` section has both `subvolume` and `target` children,
# `target` must go before `subvolume`. Otherwise, `target` will become
# a child of the last `subvolume` instead of `volume`, due to the
# order-sensitive config format.
#
# Issue: https://github.com/NixOS/nixpkgs/issues/195660
import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "btrbk-section-order";
  meta.maintainers = with lib.maintainers; [ oxalica ];

  nodes.machine = { ... }: {
    services.btrbk.instances.local = {
      onCalendar = null;
      settings = {
        timestamp_format = "long";
        target."ssh://global-target/".ssh_user = "root";
        volume."/btrfs" = {
          snapshot_dir = "/volume-snapshots";
          target."ssh://volume-target/".ssh_user = "root";
          subvolume."@subvolume" = {
            snapshot_dir = "/subvolume-snapshots";
            target."ssh://subvolume-target/".ssh_user = "root";
          };
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("basic.target")
    got = machine.succeed("cat /etc/btrbk/local.conf")
    expect = """
    backend btrfs-progs-sudo
    timestamp_format long
    target ssh://global-target/
     ssh_user root
    volume /btrfs
     snapshot_dir /volume-snapshots
     target ssh://volume-target/
      ssh_user root
     subvolume @subvolume
      snapshot_dir /subvolume-snapshots
      target ssh://subvolume-target/
       ssh_user root
    """.strip()
    print(got)
    assert got == expect
  '';
})
