# This test runs seafile (and checks if it works)

import ./make-test.nix ({ pkgs, ...} : {
  name = "seafile";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    seafile = { config, pkgs, ... }: {
      virtualisation.memorySize = 512;
      services.seafile = {
        enable = true;
        serviceUrl = "http://seafile";
      };
      networking.firewall = {
        allowedTCPPorts = [ 8000 ];
      };
      /*services.gitlab.databasePassword = "gitlab";*/
      /*systemd.services.gitlab.serviceConfig.TimeoutStartSec = "10min";*/
    };
    client = { config, pkgs, ...}: {
      virtualisation.memorySize = 256;

      environment.systemPackages = [ pkgs.seafile ];
    };
  };

  testScript = ''
    $seafile->start();
    $client->start();

    subtest "startup", sub {
      $seafile->waitForUnit("ccnet.service");
      $seafile->waitForUnit("seafile.service");
      $seafile->waitForUnit("seahub.service");

      #$seafile->execute("systemctl status -n 300 -l ccnet >&2");
      #$seafile->execute("cat /var/lib/seafile/log/ccnet.log >&2");

      #$seafile->execute("systemctl status -n 300 -l seafile >&2");
      #$seafile->execute("cat /var/lib/seafile/log/seafile.log >&2");

      $seafile->execute("systemctl status -n 300 -l seahub >&2");
      $seafile->execute("ls -la /var/lib/seafile/log/ >&2");
      $seafile->execute("cat /var/lib/seafile/log/seahub_error.log >&2");
      $seafile->execute("cat /var/lib/seafile/log/seahub_access.log >&2");
    };

    subtest "server side accessible", sub {
      $seafile->execute("netstat -l -n >&2");

      $seafile->execute("curl -f -m 1 http://seafile >&2");
      $seafile->execute("curl -f -m 1 http://seafile:8082 >&2");
      $seafile->execute("curl -f -m 1 http://seafile:8000/ >&2");
      $seafile->execute("curl -f -m 1 http://localhost:8000/ >&2");

      $seafile->execute("ls -la /var/lib/seafile/log/ >&2");
      $seafile->execute("cat /var/lib/seafile/log/seahub_error.log >&2");
      $seafile->execute("cat /var/lib/seafile/log/seahub_access.log >&2");
    };

    $client->waitForUnit("default.target");

    $client->succeed("seaf-cli --help >&2");
    $client->succeed("seaf-cli init --help >&2");
    $client->succeed("seaf-cli init -d . >&2");
    $client->succeed("seaf-cli start >&2");

    #$client->succeed("seaf-cli config --help >&2");
    $client->succeed("seaf-cli list-remote --help >&2");
    #$client->execute("seaf-cli list-remote -s http://seafile:8000 -u admin -p seafile_password >&2");

    #$client->succeed("seaf-cli create -s http://seafile:8000 -n test01 -u admin -p seafile_password -t \"first test library\" >&2");
  '';
})
