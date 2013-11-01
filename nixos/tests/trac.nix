{ pkgs, ... }:

{
  nodes = {
    storage =
      { config, pkgs, ... }:
      { services.nfs.server.enable = true;
        services.nfs.server.exports = ''
          /repos 192.168.1.0/255.255.255.0(rw,no_root_squash)
        '';
        services.nfs.server.createMountPoints = true;
      };

    postgresql =
      { config, pkgs, ... }:
      { services.postgresql.enable = true;
        services.postgresql.package = pkgs.postgresql92;
        services.postgresql.enableTCPIP = true;
        services.postgresql.authentication = ''
          # Generated file; do not edit!
          local all all                trust
          host  all all 127.0.0.1/32   trust
          host  all all ::1/128        trust
          host  all all 192.168.1.0/24 trust
        '';
      };

    webserver =
      { config, pkgs, ... }:
      { fileSystems = pkgs.lib.mkVMOverride
          [ { mountPoint = "/repos";
              device = "storage:/repos";
              fsType = "nfs";
            }
          ];
        services.httpd.enable = true;
        services.httpd.adminAddr = "root@localhost";
        services.httpd.extraSubservices = [ { serviceType = "trac"; } ];
        environment.systemPackages = [ pkgs.pythonPackages.trac pkgs.subversion ];
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

      $postgresql->waitForUnit("postgresql");
      $postgresql->succeed("createdb trac");

      $webserver->succeed("mkdir -p /repos/trac");
      $webserver->succeed("svnadmin create /repos/trac");

      $webserver->waitForUnit("httpd");
      $webserver->waitForFile("/var/trac");
      $webserver->succeed("mkdir -p /var/trac/projects/test");
      $webserver->succeed("PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/${pkgs.python.libPrefix}/site-packages trac-admin /var/trac/projects/test initenv Test postgres://root\@postgresql/trac svn /repos/trac");

      $client->waitForX;
      $client->execute("konqueror http://webserver/projects/test &");
      $client->waitForWindow(qr/Test.*Konqueror/);
      $client->sleep(30); # loading takes a long time

      $client->screenshot("screen");
    '';
}
