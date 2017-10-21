{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.stanchion;

in

{

  ###### interface

  options = {

    services.stanchion = {

      enable = mkEnableOption "stanchion";

      package = mkOption {
        type = types.package;
        default = pkgs.stanchion;
        defaultText = "pkgs.stanchion";
        example = literalExample "pkgs.stanchion";
        description = ''
          Stanchion package to use.
        '';
      };

      nodeName = mkOption {
        type = types.str;
        default = "stanchion@127.0.0.1";
        description = ''
          Name of the Erlang node.
        '';
      };

      adminKey = mkOption {
        type = types.str;
        default = "";
        description = ''
          Name of admin user.
        '';
      };

      adminSecret = mkOption {
        type = types.str;
        default = "";
        description = ''
          Name of admin secret
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
        default = "127.0.0.1:8085";
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
        default = "/var/db/stanchion";
        description = ''
          Data directory for Stanchion.
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/stanchion";
        description = ''
          Log directory for Stanchino.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional text to be appended to <filename>stanchion.conf</filename>.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    environment.etc."stanchion/advanced.config".text = ''
      [{stanchion, []}].
    '';

    environment.etc."stanchion/stanchion.conf".text = ''
      listener = ${cfg.listener}

      riak_host = ${cfg.riakHost}

      ${optionalString (cfg.adminKey == "") "#"} admin.key=${optionalString (cfg.adminKey != "") cfg.adminKey}
      ${optionalString (cfg.adminSecret == "") "#"} admin.secret=${optionalString (cfg.adminSecret != "") cfg.adminSecret}

      platform_bin_dir = ${pkgs.stanchion}/bin
      platform_data_dir = ${cfg.dataDir}
      platform_etc_dir = /etc/stanchion
      platform_lib_dir = ${pkgs.stanchion}/lib
      platform_log_dir = ${cfg.logDir}

      nodename = ${cfg.nodeName}

      distributed_cookie = ${cfg.distributedCookie}

      ${cfg.extraConfig}
    '';

    users.extraUsers.stanchion = {
      name = "stanchion";
      uid = config.ids.uids.stanchion;
      group = "stanchion";
      description = "Stanchion server user";
    };

    users.extraGroups.stanchion.gid = config.ids.gids.stanchion;

    systemd.services.stanchion = {
      description = "Stanchion Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = [
        pkgs.utillinux # for `logger`
        pkgs.bash
      ];

      environment.HOME = "${cfg.dataDir}";
      environment.STANCHION_DATA_DIR = "${cfg.dataDir}";
      environment.STANCHION_LOG_DIR = "${cfg.logDir}";
      environment.STANCHION_ETC_DIR = "/etc/stanchion";

      preStart = ''
        if ! test -e ${cfg.logDir}; then
          mkdir -m 0755 -p ${cfg.logDir}
          chown -R stanchion:stanchion ${cfg.logDir}
        fi

        if ! test -e ${cfg.dataDir}; then
          mkdir -m 0700 -p ${cfg.dataDir}
          chown -R stanchion:stanchion ${cfg.dataDir}
        fi
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/stanchion console";
        ExecStop = "${cfg.package}/bin/stanchion stop";
        StandardInput = "tty";
        User = "stanchion";
        Group = "stanchion";
        PermissionsStartOnly = true;
        # Give Stanchion a decent amount of time to clean up.
        TimeoutStopSec = 120;
        LimitNOFILE = 65536;
      };

      unitConfig.RequiresMountsFor = [
        "${cfg.dataDir}"
        "${cfg.logDir}"
        "/etc/stanchion"
      ];
    };
  };
}
