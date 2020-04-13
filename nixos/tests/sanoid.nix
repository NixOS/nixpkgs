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
  meta = with pkgs.stdenv.lib.maintainers; {
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
        datasets."pool/test".useTemplate = [ "test" ];
      };

      services.syncoid = {
        enable = true;
        sshKey = "/root/.ssh/id_ecdsa";
        commonArgs = [ "--no-sync-snap" ];
        commands."pool/test".target = "root@target:pool/test";
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
        "mkdir /tmp/mnt",
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1024M -1s",
        "udevadm settle",
        "zpool create pool /dev/vdb1",
        "zfs create -o mountpoint=legacy pool/test",
        "mount -t zfs pool/test /tmp/mnt",
        "udevadm settle",
    )
    target.succeed(
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1024M -1s",
        "udevadm settle",
        "zpool create pool /dev/vdb1",
        "udevadm settle",
    )

    source.succeed("mkdir -m 700 /root/.ssh")
    source.succeed(
        "cat '${snakeOilPrivateKey}' > /root/.ssh/id_ecdsa"
    )
    source.succeed("chmod 600 /root/.ssh/id_ecdsa")

    source.succeed("touch /tmp/mnt/test.txt")
    source.systemctl("start --wait sanoid.service")

    target.wait_for_open_port(22)
    source.systemctl("start --wait syncoid.service")
    target.succeed(
        "mkdir /tmp/mnt",
        "zfs set mountpoint=legacy pool/test",
        "mount -t zfs pool/test /tmp/mnt",
    )
    target.succeed("cat /tmp/mnt/test.txt")
  '';
})
