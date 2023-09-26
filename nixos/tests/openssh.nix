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

    server_lazy =
      { ... }:

      {
        services.openssh = { enable = true; startWhenNeeded = true; };
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };

    server_localhost_only =
      { ... }:

      {
        services.openssh = {
          enable = true; listenAddresses = [ { addr = "127.0.0.1"; port = 22; } ];
        };
      };

    server_localhost_only_lazy =
      { ... }:

      {
        services.openssh = {
          enable = true; startWhenNeeded = true; listenAddresses = [ { addr = "127.0.0.1"; port = 22; } ];
        };
      };

    server_match_rule =
      { ... }:

      {
        services.openssh = {
          enable = true; listenAddresses = [ { addr = "127.0.0.1"; port = 22; } ];
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

    client =
      { ... }: { };

  };

  testScript = ''
    start_all()

    server.wait_for_unit("sshd")

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
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server_lazy 'echo hello world' >&2",
            timeout=30
        )
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server_lazy 'ulimit -l' | grep 1024",
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
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil server_lazy true",
            timeout=30
        )

    with subtest("localhost-only"):
        server_localhost_only.succeed("ss -nlt | grep '127.0.0.1:22'")
        server_localhost_only_lazy.succeed("ss -nlt | grep '127.0.0.1:22'")

    with subtest("match-rules"):
        server_match_rule.succeed("ss -nlt | grep '127.0.0.1:22'")
  '';
})
