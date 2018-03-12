import ./make-test.nix ({ pkgs, ... }:

let inherit (import ./ssh-keys.nix pkgs)
      snakeOilPrivateKey snakeOilPublicKey;
in {
  name = "openssh";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig eelco chaoflow ];
  };

  nodes = {

    server =
      { config, pkgs, ... }:

      {
        services.openssh.enable = true;
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
        users.extraUsers.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };

    server_lazy =
      { config, pkgs, ... }:

      {
        services.openssh = { enable = true; startWhenNeeded = true; };
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
        users.extraUsers.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };

    client =
      { config, pkgs, ... }: { };

  };

  testScript = ''
    startAll;

    my $key=`${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f key -N ""`;

    $server->waitForUnit("sshd");

    subtest "manual-authkey", sub {
      $server->succeed("mkdir -m 700 /root/.ssh");
      $server->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");
      $server_lazy->succeed("mkdir -m 700 /root/.ssh");
      $server_lazy->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");

      $client->succeed("mkdir -m 700 /root/.ssh");
      $client->copyFileFromHost("key", "/root/.ssh/id_ed25519");
      $client->succeed("chmod 600 /root/.ssh/id_ed25519");

      $client->waitForUnit("network.target");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'echo hello world' >&2");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'ulimit -l' | grep 1024");

      $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server_lazy 'echo hello world' >&2");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server_lazy 'ulimit -l' | grep 1024");

    };

    subtest "configured-authkey", sub {
      $client->succeed("cat ${snakeOilPrivateKey} > privkey.snakeoil");
      $client->succeed("chmod 600 privkey.snakeoil");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null" .
                       " -o StrictHostKeyChecking=no -i privkey.snakeoil" .
                       " server true");

      $client->succeed("ssh -o UserKnownHostsFile=/dev/null" .
                       " -o StrictHostKeyChecking=no -i privkey.snakeoil" .
                       " server_lazy true");

    };
  '';
})
