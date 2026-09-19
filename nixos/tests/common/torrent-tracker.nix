{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.test-support.torrentTracker;
in
{
  options.test-support.torrentTracker = {
    enable = lib.mkEnableOption "a BitTorrent tracker to use for serving torrents in NixOS tests";

    opentrackerPackage = lib.mkPackageOption pkgs "opentracker" { };

    transmissionPackage = lib.mkPackageOption pkgs "transmission" {
      default = [ "transmission_4" ];
    };

    trackerPort = lib.mkOption {
      type = lib.types.port;
      default = 7070;
      description = "Port which the BitTorrent tracker listens on.";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port which the HTTP server serving `.torrent` files listens on.";
    };

    torrents = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }: {
            options = {
              file = lib.mkOption {
                type = lib.types.path;
                description = "Path to the file to serve as a torrent.";
                example = lib.literalExpression ''
                  pkgs.writeText "hello.txt" "..."
                '';
              };

              url = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
                default = "http://${config.networking.hostName}:${toString cfg.webPort}/${name}.torrent";
                description = "URL other nodes' BitTorrent clients can use to download the torrent file.";
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Files to serve as torrents.

        Each is created and seedeed automatically as part of starting `transmission.service`.
      '';
    };

    announceUrl = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "http://${config.networking.hostName}:${toString cfg.trackerPort}/announce";
      description = "Announce URL other nodes' BitTorrent clients can use to reach this tracker.";
    };
  };

  config =
    let
      torrentDir = "/var/lib/torrent-tracker/torrents";
      dataDir = "/var/lib/torrent-tracker/data";
    in
    lib.mkIf cfg.enable {
      services.opentracker = {
        enable = true;
        package = cfg.opentrackerPackage;
        extraOptions = "-p ${toString cfg.trackerPort}";
      };

      services.transmission = {
        enable = true;
        package = cfg.transmissionPackage;
        openPeerPorts = true;
        settings = {
          download-dir = dataDir;

          # Disable all peer discovery, not applicable in an offline environment.
          dht-enabled = false;
          pex-enabled = false;
          lpd-enabled = false;
        };
      };

      systemd.services.transmission = {
        after = [ "systemd-tmpfiles-setup.service" ];
        requires = [ "systemd-tmpfiles-setup.service" ];
        serviceConfig = {
          BindPaths = [ torrentDir ];
          ExecStartPost = lib.concatMap ({ name, value }: [
            "${lib.getExe' pkgs.coreutils "install"} -Dm644 '${value.file}' '${dataDir}/${lib.baseNameOf name}'"
            "${lib.getExe' cfg.transmissionPackage "transmission-create"} '${dataDir}/${lib.baseNameOf name}' --tracker '${cfg.announceUrl}' --outfile '${torrentDir}/${lib.baseNameOf name}.torrent'"
            "${lib.getExe' pkgs.coreutils "chmod"} 644 '${torrentDir}/${lib.baseNameOf name}.torrent'"
            "${lib.getExe' cfg.transmissionPackage "transmission-remote"} --add '${torrentDir}/${lib.baseNameOf name}.torrent' --download-dir '${dataDir}'"
          ]) (lib.attrsToList cfg.torrents);
        };
      };

      systemd.tmpfiles.settings."10-torrent-tracker" = {
        ${torrentDir}.d = {
          user = "transmission";
          group = "transmission";
          mode = "0755";
        };
        ${dataDir}.d = {
          user = "transmission";
          group = "transmission";
          mode = "0755";
        };
      };

      systemd.services.torrent-tracker-webserver =
        let
          webserver =
            pkgs.writers.writePython3Bin "torrent-tracker-webserver"
              {
                libraries = [ pkgs.python3Packages.systemd-python ];
              }
              ''
                import functools
                import http.server
                import socket
                import sys

                from systemd import daemon

                http.server.HTTPServer.address_family = socket.AF_INET6

                with http.server.HTTPServer(
                    ("::", int(sys.argv[2])),
                    functools.partial(
                        http.server.SimpleHTTPRequestHandler,
                        directory=sys.argv[1],
                    ),
                ) as httpd:
                    daemon.notify("READY=1")
                    httpd.serve_forever()
              '';
        in
        {
          description = "HTTP server for serving .torrent files";
          after = [
            "network.target"
            "systemd-tmpfiles-setup.service"
          ];
          requires = [ "systemd-tmpfiles-setup.service" ];
          serviceConfig = {
            Type = "notify";
            DynamicUser = true;
            WorkingDirectory = torrentDir;
            ExecStart = "${lib.getExe webserver} ${torrentDir} ${toString cfg.webPort}";
          };
        };

      systemd.targets.torrent-tracker = {
        wantedBy = [ "multi-user.target" ];
        after = [
          "opentracker.service"
          "transmission.service"
          "torrent-tracker-webserver.service"
        ];
        requires = [
          "opentracker.service"
          "transmission.service"
          "torrent-tracker-webserver.service"
        ];
      };

      networking.firewall.allowedTCPPorts = [
        cfg.trackerPort
        cfg.webPort
      ];
      networking.firewall.allowedUDPPorts = [ cfg.trackerPort ];
    };
}
