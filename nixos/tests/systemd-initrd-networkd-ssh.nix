import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "systemd-initrd-network-ssh";
    meta.maintainers = [ lib.maintainers.elvishjerricco ];

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          testing.initrdBackdoor = true;
          boot.initrd.systemd.enable = true;
          boot.initrd.systemd.contents."/etc/msg".text = "foo";
          boot.initrd.network = {
            enable = true;
            ssh = {
              enable = true;
              authorizedKeys = [ (lib.readFile ./initrd-network-ssh/id_ed25519.pub) ];
              port = 22;
              hostKeys = [ ./initrd-network-ssh/ssh_host_ed25519_key ];
            };
          };
        };

      client =
        { config, ... }:
        {
          environment.etc = {
            knownHosts = {
              text = lib.concatStrings [
                "server,"
                "${
                  toString (
                    lib.head (
                      lib.splitString " " (toString (lib.elemAt (lib.splitString "\n" config.networking.extraHosts) 2))
                    )
                  )
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

      client.wait_for_unit("network.target")
      with client.nested("waiting for SSH server to come up"):
          retry(ssh_is_up)

      msg = client.succeed(
          "ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'cat /etc/msg'"
      )
      assert "foo" in msg

      server.switch_root()
      server.wait_for_unit("multi-user.target")
    '';
  }
)
