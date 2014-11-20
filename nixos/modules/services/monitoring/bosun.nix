{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bosun;

  configFile = pkgs.writeText "bosun.conf" ''
    tsdbHost = ${cfg.opentsdbHost}
    httpListen = ${cfg.listenAddress}
    stateFile = ${cfg.stateFile}
    checkFrequency = 5m
  '';

in {

  options = {

    services.bosun = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run bosun.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.bosun;
        example = literalExample "pkgs.bosun";
        description = ''
          bosun binary to use.
        '';
      };

      user = mkOption {
        type = types.string;
        default = "bosun";
        description = ''
          User account under which bosun runs.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "bosun";
        description = ''
          Group account under which bosun runs.
        '';
      };

      opentsdbHost = mkOption {
        type = types.string;
        default = "localhost:4242";
        description = ''
          Host and port of the OpenTSDB database that stores bosun data.
        '';
      };

      listenAddress = mkOption {
        type = types.string;
        default = ":8070";
        description = ''
          The host address and port that bosun's web interface will listen on.
        '';
      };

      stateFile = mkOption {
        type = types.string;
        default = "/var/lib/bosun/bosun.state";
        description = ''
          Path to bosun's state file.
        '';
      };

    };

  };

  config = mkIf config.services.bosun.enable {


    systemd.services.bosun = {
      description = "bosun metrics collector (part of Bosun)";
      wantedBy = [ "multi-user.target" ];

      preStart =
        ''
        mkdir -p `dirname ${cfg.stateFile}`;
        touch ${cfg.stateFile}
        touch ${cfg.stateFile}.tmp

        if [ "$(id -u)" = 0 ]; then
          chown ${cfg.user}:${cfg.group} ${cfg.stateFile}
          chown ${cfg.user}:${cfg.group} ${cfg.stateFile}.tmp
        fi
        '';

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${cfg.package}/bin/bosun -c ${configFile}
        '';
      };
    };

    users.extraUsers.bosun = {
      description = "bosun user";
      group = "bosun";
      uid = config.ids.uids.bosun;
    };

    users.extraGroups.bosun.gid = config.ids.gids.bosun;

  };

}
