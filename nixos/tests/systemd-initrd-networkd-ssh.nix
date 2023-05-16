import ./make-test-python.nix ({ lib, ... }: {
  name = "systemd-initrd-network-ssh";
  meta.maintainers = [ lib.maintainers.elvishjerricco ];

<<<<<<< HEAD
  nodes = {
    server = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.cryptsetup ];
=======
  nodes = with lib; {
    server = { config, pkgs, ... }: {
      environment.systemPackages = [pkgs.cryptsetup];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      boot.loader.systemd-boot.enable = true;
      boot.loader.timeout = 0;
      virtualisation = {
        emptyDiskImages = [ 4096 ];
        useBootLoader = true;
<<<<<<< HEAD
        # Booting off the encrypted disk requires an available init script from
        # the Nix store
        mountHostNixStore = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        useEFIBoot = true;
      };

      specialisation.encrypted-root.configuration = {
<<<<<<< HEAD
        virtualisation.rootDevice = "/dev/mapper/root";
        virtualisation.fileSystems."/".autoFormat = true;
        boot.initrd.luks.devices = lib.mkVMOverride {
          root.device = "/dev/vdb";
=======
        virtualisation.bootDevice = "/dev/mapper/root";
        boot.initrd.luks.devices = lib.mkVMOverride {
          root.device = "/dev/vdc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
        boot.initrd.systemd.enable = true;
        boot.initrd.network = {
          enable = true;
          ssh = {
            enable = true;
<<<<<<< HEAD
            authorizedKeys = [ (lib.readFile ./initrd-network-ssh/id_ed25519.pub) ];
=======
            authorizedKeys = [ (readFile ./initrd-network-ssh/id_ed25519.pub) ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
          text = lib.concatStrings [
            "server,"
            "${
              toString (lib.head (lib.splitString " " (toString
                (lib.elemAt (lib.splitString "\n" config.networking.extraHosts) 2))))
            } "
            "${lib.readFile ./initrd-network-ssh/ssh_host_ed25519_key.pub}"
=======
          text = concatStrings [
            "server,"
            "${
              toString (head (splitString " " (toString
                (elemAt (splitString "\n" config.networking.extraHosts) 2))))
            } "
            "${readFile ./initrd-network-ssh/ssh_host_ed25519_key.pub}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        "echo somepass | cryptsetup luksFormat --type=luks2 /dev/vdb",
=======
        "echo somepass | cryptsetup luksFormat --type=luks2 /dev/vdc",
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
