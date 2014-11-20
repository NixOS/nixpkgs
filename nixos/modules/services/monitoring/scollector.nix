{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.scollector;

in {

  options = {

    services.scollector = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run scollector.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.scollector;
        example = literalExample "pkgs.scollector";
        description = ''
          scollector binary to use.
        '';
      };

      user = mkOption {
        type = types.string;
        default = "scollector";
        description = ''
          User account under which scollector runs.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "scollector";
        description = ''
          Group account under which scollector runs.
        '';
      };

      opentsdbHost = mkOption {
        type = types.string;
        default = "localhost:4242";
        description = ''
          Host and port of the OpenTSDB database that will store the collected
          data.
        '';
      };

    };

  };

  config = mkIf config.services.scollector.enable {

    systemd.services.scollector = {
      description = "scollector metrics collector (part of Bosun)";
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils pkgs.iproute ];

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${cfg.package}/bin/scollector -h=${cfg.opentsdbHost}
        '';
      };
    };

    users.extraUsers.scollector = {
      description = "scollector user";
      group = "scollector";
      uid = config.ids.uids.scollector;
    };

    users.extraGroups.scollector.gid = config.ids.gids.scollector;

  };

}
