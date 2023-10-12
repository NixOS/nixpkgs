import ./make-test-python.nix ({ lib, ... }: {
  name = "systemd-initrd-network-ssh";
  meta.maintainers = [ lib.maintainers.elvishjerricco ];

  nodes = {
    server = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.cryptsetup ];
      boot.loader.systemd-boot.enable = true;
      boot.loader.timeout = 0;
      virtualisation = {
        emptyDiskImages = [ 4096 ];
        useBootLoader = true;
        # Booting off the encrypted disk requires an available init script from
        # the Nix store
        mountHostNixStore = true;
        useEFIBoot = true;
      };

      specialisation.encrypted-root.configuration = {
        virtualisation.rootDevice = "/dev/mapper/root";
        virtualisation.fileSystems."/".autoFormat = true;
        boot.initrd.luks.devices = lib.mkVMOverride {
          root.device = "/dev/vdb";
        };
        boot.initrd.systemd.enable = true;
        boot.initrd.network = {
          enable = true;
          ssh = {
            enable = true;
            authorizedKeys = [ (lib.readFile ./initrd-network-ssh/id_ed25519.pub) ];
            port = 22;
            # Terrible hack so it works with useBootLoader
            hostKeys = [ { outPath = "${./initrd-network-ssh/ssh_host_ed25519_key}"; } ];
          };
        };
      };
    };

    client = { config, ... }: {
      environment.etc = {
        knownHosts = {
          text = lib.concatStrings [
            "server,"
            "${
              toString (lib.head (lib.splitString " " (toString
                (lib.elemAt (lib.splitString "\n" config.networking.extraHosts) 2))))
            } "
            "${lib.readFile ./initrd-network-ssh/ssh_host_ed25519_key.pub}"
          ];
        };
        sshKey = {
          source = ./initrd-network-ssh/id_ed25519;
          mode = "0600";
        };
      };
    };
  };

  testScript = ''
    start_all()

    def ssh_is_up(_) -> bool:
        status, _ = client.execute("nc -z server 22")
        return status == 0

    server.wait_for_unit("multi-user.target")
    server.succeed(
        "echo somepass | cryptsetup luksFormat --type=luks2 /dev/vdb",
        "bootctl set-default nixos-generation-1-specialisation-encrypted-root.conf",
        "sync",
    )
    server.shutdown()
    server.start()

    client.wait_for_unit("network.target")
    with client.nested("waiting for SSH server to come up"):
        retry(ssh_is_up)

    client.succeed(
        "echo somepass | ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'systemd-tty-ask-password-agent' & exit"
    )

    server.wait_for_unit("multi-user.target")
    server.succeed("mount | grep '/dev/mapper/root on /'")
  '';
})
