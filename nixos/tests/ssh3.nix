import ./make-test-python.nix ({ pkgs, ... }:

let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;
  certs = import ./common/acme/server/snakeoil-certs.nix;
in {
  name = "ssh3";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ raitobezarius ];
  };

  nodes = {
    server =
      { config, nodes, ... }:

      {
        networking = {
          interfaces.eth1.ipv4.addresses = [
            {
              address = "192.168.2.101"; prefixLength = 24;
            }
          ];
          firewall.allowedUDPPorts = [ 443 ];
          domain = certs.domain;
          extraHosts = ''
            192.168.2.101 acme.test
          '';
        };
        services.ssh3-server = {
          enable = true;
          domain = certs.domain;
          certificate = {
            publicKeyPath = certs."${certs.domain}".cert;
            privateKeyPath = certs."${certs.domain}".key;
          };
          listenAddresses = [
            {
              addr = "0.0.0.0";
              port = 443;
            }
          ];
          # Ideally, should be quite random?
          urlPath = "/ssh3-test";
        };
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
        security.pki.certificates = [
          (builtins.readFile certs.ca.cert)
        ];
      };

    client =
      { nodes, ... }: {
        networking.extraHosts = ''
          192.168.2.101 acme.test
        '';
        networking.interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.201"; prefixLength = 24; }
          ];
        };
        security.pki.certificates = [
          (builtins.readFile certs.ca.cert)
        ];
        environment.systemPackages = [ pkgs.ssh3 ];
      };

  };

  testScript = ''
    start_all()

    server.wait_for_unit("ssh3-server", timeout=30)

    with subtest("manual-authkey"):
        client.succeed("mkdir -m 700 /root/.ssh")
        client.succeed(
            '${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N ""'
        )
        public_key = client.succeed(
            "${pkgs.openssh}/bin/ssh-keygen -y -f /root/.ssh/id_ed25519"
        )
        public_key = public_key.strip()
        client.succeed("chmod 600 /root/.ssh/id_ed25519")

        server.succeed("mkdir -m 700 /root/.ssh")
        server.succeed("echo '{}' > /root/.ssh/authorized_keys".format(public_key))

        client.wait_for_unit("network.target")
        client.succeed(
            "ssh3 -v -privkey /root/.ssh/id_ed25519 root@acme.test/ssh3-test 'exit' >&2",
            timeout=60
        )
        client.succeed(
            "ssh3 -v -privkey /root/.ssh/id_ed25519 -v root@acme.test/ssh3-test 'ulimit -l && exit' | grep 1024",
            timeout=60
        )

    with subtest("configured-authkey"):
        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.succeed(
            "ssh3 -v -privkey privkey.snakeoil root@acme.test/ssh3-test exit >&2",
            timeout=30
        )
  '';
})
