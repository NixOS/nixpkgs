{ config, lib, pkgs, ... }:

let
  cfg = config.services.timetagger;
in {
  options = {
    services.timetagger = {
      enable = mkEnableOption (mdDoc "Timetagger");

      package = mkPackageOptionMD pkgs "Timetagger" {
        default = ["timetagger"];
      };

      address = mkOption {
        type = types.ipAddress;
        default = "127.0.0.1";
        description = mdDoc ''
          Address to run timetagger under
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8123;
        description = mdDoc "TCP port to bind timetagger to.";
      };
    };
  };

  config = mkIf cfg.enable {
    users = {
      users."${cfg.user}" = {
        description = "Timetagger user";
        group = cfg.group;
        isSystemUser = true;
      };
      groups."${cfg.group}" = { };
    };

    systemd.services.timetagger = {
      description = "Timetagger server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        RuntimeDirectory = "timetagger";
        CacheDirectory = "timetagger";
        RuntimeDirectoryPreserve = true;

        Environment = {
          TIMETAGGER_BIND = "${cfg.address}:${toString cfg.port}";
        };

        ExecStart = "${cfg.packages}/bin/timetagger start";
      };
    };
  };
}
