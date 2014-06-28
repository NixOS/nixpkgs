import ./make-test.nix ({ pkgs, ... }: {
  name = "phabricator";

  nodes = {
    storage =
      { config, pkgs, ... }:
      { services.nfs.server.enable = true;
        services.nfs.server.exports = ''
          /repos 192.168.1.0/255.255.255.0(rw,no_root_squash)
        '';
        services.nfs.server.createMountPoints = true;
      };

    webserver =
      { config, pkgs, ... }:
      { fileSystems = pkgs.lib.mkVMOverride
          [ { mountPoint = "/repos";
              device = "storage:/repos";
              fsType = "nfs";
            }
          ];
        networking.firewall.enable = false;
        networking.useDHCP = false;

        services = {
          httpd = {
            enable = true;
            adminAddr = "root@localhost";
            virtualHosts = [{
              hostName = "phabricator.local";
              extraSubservices = [{serviceType = "phabricator";}];
            }];
          };

          mysql = {
            enable = true;
            package = pkgs.mysql;
          };
        };

        environment.systemPackages = [ pkgs.php ];
      };

    client =
      { config, pkgs, ... }:
      { imports = [ ./common/x11.nix ];
        services.xserver.desktopManager.kde4.enable = true;
      };
  };

  testScript =
    ''
      startAll;

      $client->waitForX;

      $webserver->waitForUnit("mysql");
      $webserver->waitForUnit("httpd");
      $webserver->execute("cd /nix/store; less >/repos/log1");

      $client->sleep(30); # loading takes a long time
      $client->execute("konqueror http://webserver/ &");
      $client->sleep(90); # loading takes a long time

      $client->screenshot("screen");
    '';
})
