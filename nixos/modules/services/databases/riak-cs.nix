{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.riak-cs;

in

{

  ###### interface

  options = {

    services.riak-cs = {

      enable = mkEnableOption "riak-cs";

      package = mkOption {
        type = types.package;
        default = pkgs.riak-cs;
        defaultText = "pkgs.riak-cs";
        example = literalExample "pkgs.riak-cs";
        description = ''
          Riak package to use.
        '';
      };

      nodeName = mkOption {
        type = types.str;
        default = "riak-cs@127.0.0.1";
        description = ''
          Name of the Erlang node.
        '';
      };

      anonymousUserCreation = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Anonymous user creation.
        '';
      };

      riakHost = mkOption {
        type = types.str;
        default = "127.0.0.1:8087";
        description = ''
          Name of riak hosting service.
        '';
      };

      listener = mkOption {
        type = types.str;
        default = "127.0.0.1:8080";
        description = ''
          Name of Riak CS listening service.
        '';
      };

      stanchionHost = mkOption {
        type = types.str;
        default = "127.0.0.1:8085";
        description = ''
          Name of stanchion hosting service.
        '';
      };

      stanchionSsl = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Tell stanchion to use SSL.
        '';
      };

      distributedCookie = mkOption {
        type = types.str;
        default = "riak";
        description = ''
          Cookie for distributed node communication.  All nodes in the
          same cluster should use the same cookie or they will not be able to
          communicate.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/db/riak-cs";
        description = ''
          Data directory for Riak CS.
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/riak-cs";
        description = ''
          Log directory for Riak CS.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional text to be appended to <filename>riak-cs.conf</filename>.
        '';
      };

      extraAdvancedConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional text to be appended to <filename>advanced.config</filename>.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];
    environment.etc."riak-cs/riak-cs.conf".text = ''
      nodename = ${cfg.nodeName}
      distributed_cookie = ${cfg.distributedCookie}

      platform_log_dir = ${cfg.logDir}

      riak_host = ${cfg.riakHost}
      listener = ${cfg.listener}
      stanchion_host = ${cfg.stanchionHost}

      anonymous_user_creation = ${if cfg.anonymousUserCreation then "on" else "off"}

      ${cfg.extraConfig}
    '';

    environment.etc."riak-cs/advanced.config".text = ''
      ${cfg.extraAdvancedConfig}
    '';

    users.users.riak-cs = {
      name = "riak-cs";
      uid = config.ids.uids.riak-cs;
      group = "riak";
      description = "Riak CS server user";
    };

  systemd.services.riak-cs = {
      description = "Riak CS Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = [
        pkgs.utillinux # for `logger`
        pkgs.bash
      ];

      environment.HOME = "${cfg.dataDir}";
      environment.RIAK_CS_DATA_DIR = "${cfg.dataDir}";
      environment.RIAK_CS_LOG_DIR = "${cfg.logDir}";
      environment.RIAK_CS_ETC_DIR = "/etc/riak";

      preStart = ''
        if ! test -e ${cfg.logDir}; then
          mkdir -m 0755 -p ${cfg.logDir}
          chown -R riak-cs ${cfg.logDir}
        fi

        if ! test -e ${cfg.dataDir}; then
          mkdir -m 0700 -p ${cfg.dataDir}
          chown -R riak-cs ${cfg.dataDir}
        fi
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/riak-cs console";
        ExecStop = "${cfg.package}/bin/riak-cs stop";
        StandardInput = "tty";
        User = "riak-cs";
        Group = "riak-cs";
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
