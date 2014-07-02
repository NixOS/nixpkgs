import ./make-test.nix ({ pkgs, ... }:

let
  snakeOilPrivateKey = pkgs.writeText "privkey.snakeoil" ''
    -----BEGIN EC PRIVATE KEY-----
    MHcCAQEEIHQf/khLvYrQ8IOika5yqtWvI0oquHlpRLTZiJy5dRJmoAoGCCqGSM49
    AwEHoUQDQgAEKF0DYGbBwbj06tA3fd/+yP44cvmwmHBWXZCKbS+RQlAKvLXMWkpN
    r1lwMyJZoSGgBHoUahoYjTh9/sJL7XLJtA==
    -----END EC PRIVATE KEY-----
  '';

  snakeOilPublicKey = pkgs.lib.concatStrings [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHA"
    "yNTYAAABBBChdA2BmwcG49OrQN33f/sj+OHL5sJhwVl2Qim0vkUJQCry1zFpKTa"
    "9ZcDMiWaEhoAR6FGoaGI04ff7CS+1yybQ= sakeoil"
  ];

in {
  name = "openssh";

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

    client =
      { config, pkgs, ... }: { };

  };

  testScript = ''
    startAll;

    my $key=`${pkgs.openssh}/bin/ssh-keygen -t dsa -f key -N ""`;

    $server->waitForUnit("sshd");

    subtest "manual-authkey", sub {
      $server->succeed("mkdir -m 700 /root/.ssh");
      $server->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");

      $client->succeed("mkdir -m 700 /root/.ssh");
      $client->copyFileFromHost("key", "/root/.ssh/id_dsa");
      $client->succeed("chmod 600 /root/.ssh/id_dsa");

      $client->waitForUnit("network.target");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'echo hello world' >&2");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'ulimit -l' | grep 1024");
    };

    subtest "configured-authkey", sub {
      $client->succeed("cat ${snakeOilPrivateKey} > privkey.snakeoil");
      $client->succeed("chmod 600 privkey.snakeoil");
      $client->succeed("ssh -o UserKnownHostsFile=/dev/null" .
                       " -o StrictHostKeyChecking=no -i privkey.snakeoil" .
                       " server true");
    };
  '';
})
