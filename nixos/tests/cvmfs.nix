{ lib, ... }:
{
  name = "cvmfs";

  meta.maintainers = with lib.maintainers; [ olantwin ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.cvmfs = {
        enable = true;
        repositories = [ "sft.cern.ch" ];
        httpProxy = "DIRECT";
        clientProfile = "single";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # Service user exists
    machine.succeed("id cvmfs")

    # Config files generated correctly
    machine.succeed("test -f /etc/cvmfs/default.conf")
    machine.succeed("test -f /etc/cvmfs/default.local")
    machine.succeed("grep -q sft.cern.ch /etc/cvmfs/default.local")
    machine.succeed("grep -q DIRECT /etc/cvmfs/default.local")

    # Public keys installed
    machine.succeed("test -d /etc/cvmfs/keys/cern.ch")

    # FUSE module loaded
    machine.succeed("lsmod | grep -q fuse")

    # Automount unit active
    machine.succeed("systemctl is-active cvmfs-sft.cern.ch.automount")

    # Cache directory exists with correct ownership
    machine.succeed("stat -c '%U:%G' /var/cache/cvmfs | grep -q cvmfs:cvmfs")

    # Mount helpers available
    machine.succeed("which mount.cvmfs")
    machine.succeed("which mount.fuse.cvmfs2")

    # Binary runs
    machine.succeed("cvmfs2 --help")
  '';
}
