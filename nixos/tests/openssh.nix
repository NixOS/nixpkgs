import ./make-test-python.nix ({ pkgs, ... }:

let inherit (import ./ssh-keys.nix pkgs)
      snakeOilPrivateKey snakeOilPublicKey snakeOilEd25519PrivateKey snakeOilEd25519PublicKey;
in {
  name = "openssh";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  nodes = {

    server =
      { ... }:

      {
        services.openssh.enable = true;
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };

    server-allowed-users =
      { ... }:

      {
        services.openssh = { enable = true; settings.AllowUsers = [ "alice" "bob" ]; };
        users.groups = { alice = { }; bob = { }; carol = { }; };
        users.users = {
          alice = { isNormalUser = true; group = "alice"; openssh.authorizedKeys.keys = [ snakeOilPublicKey ]; };
          bob = { isNormalUser = true; group = "bob"; openssh.authorizedKeys.keys = [ snakeOilPublicKey ]; };
          carol = { isNormalUser = true; group = "carol"; openssh.authorizedKeys.keys = [ snakeOilPublicKey ]; };
        };
      };

    server-lazy =
      { ... }:

      {
        services.openssh = { enable = true; startWhenNeeded = true; };
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };

    server-lazy-socket = {
      virtualisation.vlans = [ 1 2 ];
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        ports = [ 2222 ];
        listenAddresses = [ { addr = "0.0.0.0"; } ];
      };
      users.users.root.openssh.authorizedKeys.keys = [
        snakeOilPublicKey
      ];
    };

    server-localhost-only =
      { ... }:

      {
        services.openssh = {
          enable = true; listenAddresses = [ { addr = "127.0.0.1"; port = 22; } ];
        };
      };

    server-localhost-only-lazy =
      { ... }:

      {
        services.openssh = {
          enable = true; startWhenNeeded = true; listenAddresses = [ { addr = "127.0.0.1"; port = 22; } ];
        };
      };

    server-match-rule =
      { ... }:

      {
        services.openssh = {
          enable = true; listenAddresses = [ { addr = "127.0.0.1"; port = 22; } { addr = "[::]"; port = 22; } ];
          extraConfig = ''
            # Combined test for two (predictable) Match criterias
            Match LocalAddress 127.0.0.1 LocalPort 22
              PermitRootLogin yes

            # Separate tests for Match criterias
            Match User root
              PermitRootLogin yes
            Match Group root
              PermitRootLogin yes
            Match Host nohost.example
              PermitRootLogin yes
            Match LocalAddress 127.0.0.1
              PermitRootLogin yes
            Match LocalPort 22
              PermitRootLogin yes
            Match RDomain nohost.example
              PermitRootLogin yes
            Match Address 127.0.0.1
              PermitRootLogin yes
          '';
        };
      };

    server-no-openssl =
      { ... }:
      {
        services.openssh = {
          enable = true;
          package = pkgs.opensshPackages.openssh.override {
            linkOpenssl = false;
          };
          hostKeys = [
            { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
          ];
          settings = {
            # Since this test is against an OpenSSH-without-OpenSSL,
            # we have to override NixOS's defaults ciphers (which require OpenSSL)
            # and instead set these to null, which will mean OpenSSH uses its defaults.
            # Expectedly, OpenSSH's defaults don't require OpenSSL when it's compiled
            # without OpenSSL.
            Ciphers = null;
            KexAlgorithms = null;
            Macs = null;
          };
        };
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilEd25519PublicKey
        ];
      };

    server-no-pam =
      { pkgs, ... }:
      {
        services.openssh = {
          enable = true;
          package = pkgs.opensshPackages.openssh.override {
            withPAM = false;
          };
          settings = {
            UsePAM = false;
          };
        };
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };

    client =
      { ... }: {
        virtualisation.vlans = [ 1 2 ];
      };

  };

  testScript = ''
    start_all()

    server.wait_for_unit("sshd", timeout=30)
    server_allowed_users.wait_for_unit("sshd", timeout=30)
    server_localhost_only.wait_for_unit("sshd", timeout=30)
    server_match_rule.wait_for_unit("sshd", timeout=30)
    server_no_openssl.wait_for_unit("sshd", timeout=30)
    server_no_pam.wait_for_unit("sshd", timeout=30)

    server_lazy.wait_for_unit("sshd.socket", timeout=30)
    server_localhost_only_lazy.wait_for_unit("sshd.socket", timeout=30)
    server_lazy_socket.wait_for_unit("sshd.socket", timeout=30)

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
        server_lazy.succeed("mkdir -m 700 /root/.ssh")
        server_lazy.succeed("echo '{}' > /root/.ssh/authorized_keys".format(public_key))

        client.wait_for_unit("network.target")
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'echo hello world' >&2",
            timeout=30
        )
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'ulimit -l' | grep 1024",
            timeout=30
        )

        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server-lazy 'echo hello world' >&2",
            timeout=30
        )
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server-lazy 'ulimit -l' | grep 1024",
            timeout=30
        )

    with subtest("socket activation on a non-standard port"):
        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        # The final segment in this IP is allocated according to the alphabetical order of machines in this test.
        client.succeed(
            "ssh -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil root@192.168.2.5 true",
            timeout=30
        )

    with subtest("configured-authkey"):
        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil server true",
            timeout=30
        )
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil server-lazy true",
            timeout=30
        )

    with subtest("localhost-only"):
        server_localhost_only.succeed("ss -nlt | grep '127.0.0.1:22'")
        server_localhost_only_lazy.succeed("ss -nlt | grep '127.0.0.1:22'")

    with subtest("match-rules"):
        server_match_rule.succeed("ss -nlt | grep '127.0.0.1:22'")

    with subtest("allowed-users"):
        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil alice@server-allowed-users true",
            timeout=30
        )
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil bob@server-allowed-users true",
            timeout=30
        )
        client.fail(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil carol@server-allowed-users true",
            timeout=30
        )

    with subtest("no-openssl"):
        client.succeed(
            "cat ${snakeOilEd25519PrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil server-no-openssl true",
            timeout=30
        )

    with subtest("no-pam"):
        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil server-no-pam true",
            timeout=30
        )
  '';
})
