import ./make-test-python.nix (
  {
    pkgs,
    lib,
    package,
    ...
  }:
  let
    qgisPackage = package.override { withServer = true; };
    testScript = pkgs.writeTextFile {
      name = "qgis-test.py";
      text = (builtins.readFile ../../pkgs/applications/gis/qgis/test.py);
    };
  in
  {
    name = "qgis";
    meta = {
      maintainers = lib.teams.geospatial.members;
    };

    nodes = {
      machine =
        { config, pkgs, ... }:

        let
          qgisServerUser = config.services.nginx.user;
          qgisServerSocket = "/run/qgis_mapserv.socket";
        in
        {
          virtualisation.diskSize = 2 * 1024;

          imports = [ ./common/x11.nix ];
          environment.systemPackages = [
            qgisPackage
          ];

          systemd.sockets.qgis-server = {
            listenStreams = [ qgisServerSocket ];
            socketConfig = {
              Accept = false;
              SocketUser = qgisServerUser;
              SocketMode = 600;
            };
            wantedBy = [
              "sockets.target"
              "qgis-server.service"
            ];
            before = [ "qgis-server.service" ];
          };

          systemd.services.qgis-server = {
            description = "QGIS server";
            serviceConfig = {
              User = qgisServerUser;
              StandardOutput = "null";
              StandardError = "journal";
              StandardInput = "socket";
              Environment = [
                "QT_QPA_PLATFORM_PLUGIN_PATH=${pkgs.libsForQt5.qt5.qtbase}/${pkgs.libsForQt5.qt5.qtbase.qtPluginPrefix}/platforms"
                "QGIS_SERVER_LOG_LEVEL=0"
                "QGIS_SERVER_LOG_STDERR=1"
              ];
              ExecStart = "${qgisPackage}/lib/cgi-bin/qgis_mapserv.fcgi";
            };
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
          };

          services.nginx = {
            enable = true;
            virtualHosts."qgis" = {
              locations."~".extraConfig = ''
                gzip off;
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_pass unix:${qgisServerSocket};
              '';
            };
          };
        };
    };

    testScript = ''
      start_all()

      # test desktop
      machine.succeed("${qgisPackage}/bin/qgis --version | grep 'QGIS ${qgisPackage.version}'")
      machine.succeed("${qgisPackage}/bin/qgis --code ${testScript}")

      # test server
      machine.succeed("${qgisPackage}/bin/qgis_mapserver --version | grep 'QGIS ${qgisPackage.version}'")

      machine.succeed("curl --head http://localhost | grep 'Server:.*${qgisPackage.version}'")
      machine.succeed("curl http://localhost/index.json | grep 'Landing page as JSON'")
    '';
  }
)
