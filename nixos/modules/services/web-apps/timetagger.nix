
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.timetagger;
in {
  options = {
    services.timetagger = {
      enable = mkEnableOption (mdDoc "Timetagger");

      package = mkOption {
        type = types.package;
        default = pkgs.timetagger;
        defaultText = literalExpression "pkgs.timetagger";
        description = mdDoc "Timetagger package to use.";
      };

      user = mkOption {
        type = types.nonEmptyStr;
        default = "timetagger";
        description = mdDoc "User account under which timetagger runs.";
      };

      group = mkOption {
        type = types.nonEmptyStr;
        default = "timetagger";
        description = mdDoc "Group account under which timetagger runs.";
      };

      address = mkOption {
        type = ipAddress;
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
      description = "Timetagger configuration";
      wants = [ "network-online.service" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = "timetagger";
        CacheDirectory = "timetagger";
        RuntimeDirectoryPreserve = true;

        Environment = {
          TIMETAGGER_BIND = "${cfg.address}:${cfg.port}";
        };

        ExecStart = "${cfg.packages}/bin/.timetagger-wrapper start";
      };
    };
  };
}
