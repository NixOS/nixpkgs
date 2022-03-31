import ./make-test-python.nix ({pkgs, ... }:
{ 
  name = "quotas";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ zupo ];
  };
  nodes.machine = {
    virtualisation = {
      emptyDiskImages = [ 1 ];
      fileSystems = {
        "/mnt" = {
          device = "/dev/vdb";
          fsType = "ext4";
          autoFormat = true;
          options = [
            "defaults"
            # Not sure why this is necessary..
            "usrquota"
            "grpquota"
          ];
        };
      };
    };

    quotas = {
      enable = true;
      fileSystems = {
        "/mnt" = {
          enable = true;
          userquotas = {
            root = {
              enable = true;
              block-softlimit = 100;
              block-hardlimit = 200;
              inode-softlimit = 300;
              inode-hardlimit = 400;
            };
          };
        };
      };
    };
  };

  testScript = ''
    start_all()

    out = machine.succeed("cat /etc/fstab")
    assert "usrquota" in out
    assert "grpquota" in out

    machine.systemctl("cat set-disk-quotas.service")
    machine.systemctl("start set-disk-quotas.service")
      
    machine.succeed("quotastats -a")
    machine.succeed("quotastats -a")
    machine.succeed("repquota -a")
  '';
})
