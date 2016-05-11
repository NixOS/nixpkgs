{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.riak;

in

{

  ###### interface

  options = {

    services.riak = {

      enable = mkEnableOption' {
        name = "riak";
        broken = true;
        package = literalPackage pkgs "pkgs.riak";
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.riak2";
        description = ''
          Riak package to use.
        '';
      };

      nodeName = mkOption {
        type = types.string;
        default = "riak@127.0.0.1";
        description = ''
          Name of the Erlang node.
        '';
      };

      distributedCookie = mkOption {
        type = types.string;
        default = "riak";
        description = ''
          Cookie for distributed node communication.  All nodes in the
          same cluster should use the same cookie or they will not be able to
          communicate.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/db/riak";
        description = ''
          Data directory for Riak.
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/riak";
        description = ''
          Log directory for Riak.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional text to be appended to <filename>riak.conf</filename>.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];
    environment.etc."riak/riak.conf".text = ''
      nodename = ${cfg.nodeName}
      distributed_cookie = ${cfg.distributedCookie}

      platform_log_dir = ${cfg.logDir}
      platform_etc_dir = /etc/riak
      platform_data_dir = ${cfg.dataDir}

      ${cfg.extraConfig}
    '';

    users.extraUsers.riak = {
      name = "riak";
      uid = config.ids.uids.riak;
      group = "riak";
      description = "Riak server user";
    };

    users.extraGroups.riak.gid = config.ids.gids.riak;

    systemd.services.riak = {
      description = "Riak Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = [
        pkgs.utillinux # for `logger`
        pkgs.bash
      ];

      environment.RIAK_DATA_DIR = "${cfg.dataDir}";
      environment.RIAK_LOG_DIR = "${cfg.logDir}";
      environment.RIAK_ETC_DIR = "/etc/riak";

      preStart = ''
        if ! test -e ${cfg.logDir}; then
          mkdir -m 0755 -p ${cfg.logDir}
          chown -R riak ${cfg.logDir}
        fi

        if ! test -e ${cfg.dataDir}; then
          mkdir -m 0700 -p ${cfg.dataDir}
          chown -R riak ${cfg.dataDir}
        fi
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/riak console";
        ExecStop = "${cfg.package}/bin/riak stop";
        StandardInput = "tty";
        User = "riak";
        Group = "riak";
        PermissionsStartOnly = true;
        # Give Riak a decent amount of time to clean up.
        TimeoutStopSec = 120;
        LimitNOFILE = 65536;
      };

      unitConfig.RequiresMountsFor = [
        "${cfg.dataDir}"
        "${cfg.logDir}"
        "/etc/riak"
      ];
    };

  };

}
