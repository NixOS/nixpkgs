{ pkgs, ... }:

{
  nodes = {

    server =
      { config, pkgs, ... }:

      {
        services.openssh.enable = true;
        security.pam.services.sshd.limits =
          [ { domain = "*"; item = "memlock"; type = "-"; value = 1024; } ];
      };

    client =
      { config, pkgs, ... }: { };

  };

  testScript = ''
    startAll;

    my $key=`${pkgs.openssh}/bin/ssh-keygen -t dsa -f key -N ""`;

    $server->waitForUnit("sshd");

    $server->succeed("mkdir -m 700 /root/.ssh");
    $server->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");

    $client->succeed("mkdir -m 700 /root/.ssh");
    $client->copyFileFromHost("key", "/root/.ssh/id_dsa");
    $client->succeed("chmod 600 /root/.ssh/id_dsa");

    $client->waitForUnit("network.target");
    $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'echo hello world' >&2");
    $client->succeed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'ulimit -l' | grep 1024");
  '';
}
