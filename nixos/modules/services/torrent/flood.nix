{ config, lib, pkgs, ... }:

let
  cfg = config.services.flood;
in
{
  options = {
    services = {
      flood = {
        enable = lib.mkEnableOption (lib.mdDoc "Flood daemon");

        package = lib.mkPackageOptionMD pkgs "flood" { };

        baseUrl = lib.mkOption {
          type = lib.types.str;
          default = "/";
          description = lib.mdDoc ''
            This URI will prefix all of Flood's HTTP requests.
          '';
        };

        address = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = lib.mdDoc ''
            The host (address) that Flood should listen for web connections on.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = lib.mdDoc ''
            The port that Flood should listen for web connections on.
          '';
        };

        openFirewall = lib.mkOption {
          default = false;
          type = lib.types.bool;
          description = lib.mdDoc ''
            Whether to open the firewall for the port in
            {option}`services.flood.port`.
          '';
        };

        ssl = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = lib.mdDoc ''
              Enable SSL.
            '';
          };

          key = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = lib.mdDoc ''
              Absolute path to private key for SSL.
            '';
          };

          cert = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = lib.mdDoc ''
              Absolute path to fullchain cert for SSL.
            '';
          };
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "flood";
          description = lib.mdDoc ''
            User account under which flood runs.
          '';
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "flood";
          description = lib.mdDoc ''
            Group under which flood runs.
          '';
        };

        allowedPaths = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          description = lib.mdDoc ''
            List of allowed paths for file operations.
          '';
        };

        auth = {
          deluge = {
            host = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Host of Deluge RPC interface.
              '';
            };
            port = lib.mkOption {
              type = lib.types.nullOr lib.types.port;
              default = null;
              description = lib.mdDoc ''
                Port of Deluge RPC interface.
              '';
            };
            user = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Username of Deluge RPC interface.
              '';
            };
            pass = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Password of Deluge RPC interface.
              '';
            };
          };
          rtorrent = {
            host = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Host of rTorrent's SCGI interface.
              '';
            };
            port = lib.mkOption {
              type = lib.types.nullOr lib.types.port;
              default = null;
              description = lib.mdDoc ''
                Port of rTorrent's SCGI interface.
              '';
            };
            socket = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = lib.mdDoc ''
                Path to rTorrent's SCGI unix socket.
              '';
            };
          };
          qbittorrent = {
            url = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                URL to qBittorrent Web API.
              '';
            };
            user = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Username of qBittorrent Web API.
              '';
            };
            pass = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Password of qBittorrent Web API.
              '';
            };
          };
          transmission = {
            url = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                URL to Transmission RPC interface.
              '';
            };
            user = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Username of Transmission RPC interface.
              '';
            };
            pass = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc ''
                Password of Transmission RPC interface.
              '';
            };
          };
        };
      };
    };
  };

  config =
    let
      addAuthOpt = prefix: opt:
        lib.mapAttrsToList
          (k: v:
            "--${prefix}${toString k} ${toString v}")
          (lib.filterAttrs (k: v: !isNull v) opt);
      delugeAuth = addAuthOpt "de" cfg.auth.deluge;
      rtorrentAuth = addAuthOpt "rt" cfg.auth.rtorrent;
      qbittorrentAuth = addAuthOpt "qb" cfg.auth.qbittorrent;
      transmissionAuth = addAuthOpt "tr" cfg.auth.transmission;
      authOpts = lib.lists.findSingle (x: x != [ ]) [ ] [ null ] [ delugeAuth rtorrentAuth qbittorrentAuth transmissionAuth ];
      args = [
        "--rundir %S/flood"
        "--baseuri ${cfg.baseUrl}"
        "--host ${cfg.address}"
        "--port ${toString cfg.port}"
      ]
      ++ lib.optionals cfg.ssl.enable [ "--ssl" ]
      ++ lib.optionals (cfg.ssl.enable && (!isNull cfg.ssl.key)) [ "--sslkey ${cfg.ssl.key}" ]
      ++ lib.optionals (cfg.ssl.enable && (!isNull cfg.ssl.cert)) [ "--sslcert ${cfg.ssl.cert}" ]
      ++ lib.optionals (authOpts != [ ]) [ "--auth none" ]
      ++ authOpts
      ++ map (x: "--allowedpath ${toString x}") cfg.allowedPaths;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = authOpts != [ null ];
          message = "Only one client authentication must be configured";
        }
      ];
      systemd.services.flood =
        {
          after = [ "network.target" ];
          description = "Flood Daemon";
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.mediainfo ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/flood ${lib.concatStringsSep " " args}";
            Restart = "on-failure";
            UMask = "077";
            DynamicUser = true;
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "flood";
            ReadWritePaths = cfg.allowedPaths ++
              lib.optionals (!isNull cfg.auth.rtorrent.socket) [ "-${cfg.auth.rtorrent.socket}" ];

            AmbientCapabilities = [ "" ];
            CapabilityBoundingSet = [ "" ];
            DevicePolicy = "closed";
            ProtectSystem = "full";
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProcSubset = "pid";
            ProtectProc = "invisible";
            RemoveIPC = true;
            RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "~@cpu-emulation"
              "~@debug"
              "~@mount"
              "~@obsolete"
              "~@privileged"
              "~@resources"
            ];
          };
        };
      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
    };
}
