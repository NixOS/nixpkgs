import ./make-test-python.nix ({ pkgs, ... }:

let inherit (import ./ssh-keys.nix pkgs)
      snakeOilPrivateKey snakeOilPublicKey;
in {
  name = "openssh";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aszlig eelco ];
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

    server_allowedusers =
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

    client =
      { ... }: { };

  };

  testScript = ''
    start_all()

    server.wait_for_unit("sshd", timeout=30)
    server_localhost_only.wait_for_unit("sshd", timeout=30)
    server_match_rule.wait_for_unit("sshd", timeout=30)

    server_lazy.wait_for_unit("sshd.socket", timeout=30)
    server_localhost_only_lazy.wait_for_unit("sshd.socket", timeout=30)

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
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil alice@server_allowedusers true",
            timeout=30
        )
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil bob@server_allowedusers true",
            timeout=30
        )
        client.fail(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil carol@server_allowedusers true",
            timeout=30
        )
  '';
})
