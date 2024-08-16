{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.dgraph;
  settingsFormat = pkgs.formats.json {};
  configFile = settingsFormat.generate "config.json" cfg.settings;
  dgraphWithNode = pkgs.runCommand "dgraph" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${cfg.package}/bin/dgraph $out/bin/dgraph \
      --prefix PATH : "${lib.makeBinPath [ pkgs.nodejs ]}" \
  '';
  securityOptions = {
      NoNewPrivileges = true;

      AmbientCapabilities = "";
      CapabilityBoundingSet = "";

      DeviceAllow = "";

      LockPersonality = true;

      PrivateTmp = true;
      PrivateDevices = true;
      PrivateUsers = true;

      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;

      RemoveIPC = true;

      RestrictNamespaces = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;

      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        "~@cpu-emulation" "~@debug" "~@keyring" "~@memlock" "~@obsolete" "~@privileged" "~@setuid"
      ];
  };
in
{
  options = {
    services.dgraph = {
      enable = mkEnableOption "Dgraph native GraphQL database with a graph backend";

      package = lib.mkPackageOption pkgs "dgraph" { };

      settings = mkOption {
        type = settingsFormat.type;
        default = {};
        description = ''
          Contents of the dgraph config. For more details see https://dgraph.io/docs/deploy/config
        '';
      };

      alpha = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            The host which dgraph alpha will be run on.
          '';
        };
        port = mkOption {
          type = types.port;
          default = 7080;
          description = ''
            The port which to run dgraph alpha on.
          '';
        };

      };

      zero = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            The host which dgraph zero will be run on.
          '';
        };
        port = mkOption {
          type = types.port;
          default = 5080;
          description = ''
            The port which to run dgraph zero on.
          '';
        };
      };

    };
  };

  config = mkIf cfg.enable {
    services.dgraph.settings = {
      badger.compression = mkDefault "zstd:3";
    };

    systemd.services.dgraph-zero = {
      description = "Dgraph native GraphQL database with a graph backend. Zero controls node clustering";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        StateDirectory = "dgraph-zero";
        WorkingDirectory = "/var/lib/dgraph-zero";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/dgraph zero --my ${cfg.zero.host}:${toString cfg.zero.port}";
        Restart = "on-failure";
      } // securityOptions;
    };

    systemd.services.dgraph-alpha = {
      description = "Dgraph native GraphQL database with a graph backend. Alpha serves data";
      after = [ "network.target" "dgraph-zero.service" ];
      requires = [ "dgraph-zero.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        StateDirectory = "dgraph-alpha";
        WorkingDirectory = "/var/lib/dgraph-alpha";
        DynamicUser = true;
        ExecStart = "${dgraphWithNode}/bin/dgraph alpha --config ${configFile} --my ${cfg.alpha.host}:${toString cfg.alpha.port} --zero ${cfg.zero.host}:${toString cfg.zero.port}";
        ExecStop = ''
          ${pkgs.curl}/bin/curl --data "mutation { shutdown { response { message code } } }" \
              --header 'Content-Type: application/graphql' \
              -X POST \
              http://localhost:8080/admin
        '';
        Restart = "on-failure";
      } // securityOptions;
    };
  };

  meta.maintainers = with lib.maintainers; [ happysalada ];
}
