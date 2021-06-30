import ./make-test-python.nix ({ pkgs, ... }: let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;

  commonConfig = { pkgs, ... }: {
    virtualisation.emptyDiskImages = [ 2048 ];
    boot.supportedFilesystems = [ "zfs" ];
    environment.systemPackages = [ pkgs.parted ];
  };
in {
  name = "sanoid";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lopsided98 ];
  };

  nodes = {
    source = { ... }: {
      imports = [ commonConfig ];
      networking.hostId = "daa82e91";

      programs.ssh.extraConfig = ''
        UserKnownHostsFile=/dev/null
        StrictHostKeyChecking=no
      '';

      services.sanoid = {
        enable = true;
        templates.test = {
          hourly = 12;
          daily = 1;
          monthly = 1;
          yearly = 1;

          autosnap = true;
        };
        datasets."pool/sanoid".use_template = [ "test" ];
        extraArgs = [ "--verbose" ];
      };

      services.syncoid = {
        enable = true;
        sshKey = "/var/lib/syncoid/id_ecdsa";
        commands = {
          # Sync snapshot taken by sanoid
          "pool/sanoid" = {
            target = "root@target:pool/sanoid";
            extraArgs = [ "--no-sync-snap" ];
          };
          # Take snapshot and sync
          "pool/syncoid".target = "root@target:pool/syncoid";
        };
      };
    };
    target = { ... }: {
      imports = [ commonConfig ];
      networking.hostId = "dcf39d36";

      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
    };
  };

  testScript = ''
    source.succeed(
        "mkdir /mnt",
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1024M -1s",
        "udevadm settle",
        "zpool create pool -R /mnt /dev/vdb1",
        "zfs create pool/sanoid",
        "zfs create pool/syncoid",
        "udevadm settle",
    )
    target.succeed(
        "mkdir /mnt",
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1024M -1s",
        "udevadm settle",
        "zpool create pool -R /mnt /dev/vdb1",
        "udevadm settle",
    )

    source.succeed(
        "mkdir -m 700 -p /var/lib/syncoid",
        "cat '${snakeOilPrivateKey}' > /var/lib/syncoid/id_ecdsa",
        "chmod 600 /var/lib/syncoid/id_ecdsa",
        "chown -R syncoid:syncoid /var/lib/syncoid/",
    )

    # Take snapshot with sanoid
    source.succeed("touch /mnt/pool/sanoid/test.txt")
    source.systemctl("start --wait sanoid.service")

    # Sync snapshots
    target.wait_for_open_port(22)
    source.succeed("touch /mnt/pool/syncoid/test.txt")
    source.systemctl("start --wait syncoid.service")
    target.succeed("cat /mnt/pool/sanoid/test.txt")
    target.succeed("cat /mnt/pool/syncoid/test.txt")
  '';
})
