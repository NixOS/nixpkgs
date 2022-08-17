{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.ejabberd;

  ctlcfg = pkgs.writeText "ejabberdctl.cfg" ''
    ERL_EPMD_ADDRESS=127.0.0.1
    ${cfg.ctlConfig}
  '';

  ectl = ''${cfg.package}/bin/ejabberdctl ${optionalString (cfg.configFile != null) "--config ${cfg.configFile}"} --ctl-config "${ctlcfg}" --spool "${cfg.spoolDir}" --logs "${cfg.logsDir}"'';

  dumps = lib.escapeShellArgs cfg.loadDumps;

in {

  ###### interface

  options = {

    services.ejabberd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable ejabberd server";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ejabberd;
        defaultText = literalExpression "pkgs.ejabberd";
        description = lib.mdDoc "ejabberd server package to use";
      };

      user = mkOption {
        type = types.str;
        default = "ejabberd";
        description = lib.mdDoc "User under which ejabberd is ran";
      };

      group = mkOption {
        type = types.str;
        default = "ejabberd";
        description = lib.mdDoc "Group under which ejabberd is ran";
      };

      spoolDir = mkOption {
        type = types.path;
        default = "/var/lib/ejabberd";
        description = lib.mdDoc "Location of the spooldir of ejabberd";
      };

      logsDir = mkOption {
        type = types.path;
        default = "/var/log/ejabberd";
        description = lib.mdDoc "Location of the logfile directory of ejabberd";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        description = lib.mdDoc "Configuration file for ejabberd in YAML format";
        default = null;
      };

      ctlConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Configuration of ejabberdctl";
      };

      loadDumps = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc "Configuration dumps that should be loaded on the first startup";
        example = literalExpression "[ ./myejabberd.dump ]";
      };

      imagemagick = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Add ImageMagick to server's path; allows for image thumbnailing";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users = optionalAttrs (cfg.user == "ejabberd") {
      ejabberd = {
        group = cfg.group;
        home = cfg.spoolDir;
        createHome = true;
        uid = config.ids.uids.ejabberd;
      };
    };

    users.groups = optionalAttrs (cfg.group == "ejabberd") {
      ejabberd.gid = config.ids.gids.ejabberd;
    };

    systemd.services.ejabberd = {
      description = "ejabberd server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.findutils pkgs.coreutils ] ++ lib.optional cfg.imagemagick pkgs.imagemagick;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${ectl} foreground";
        ExecStop = "${ectl} stop";
        ExecReload = "${ectl} reload_config";
      };

      preStart = ''
        if [ -z "$(ls -A '${cfg.spoolDir}')" ]; then
          touch "${cfg.spoolDir}/.firstRun"
        fi
      '';

      postStart = ''
        while ! ${ectl} status >/dev/null 2>&1; do
          if ! kill -0 "$MAINPID"; then exit 1; fi
          sleep 0.1
        done

        if [ -e "${cfg.spoolDir}/.firstRun" ]; then
          rm "${cfg.spoolDir}/.firstRun"
          for src in ${dumps}; do
            find "$src" -type f | while read dump; do
              echo "Loading configuration dump at $dump"
              ${ectl} load "$dump"
            done
          done
        fi
      '';
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.logsDir}' 0750 ${cfg.user} ${cfg.group} -"
      "d '${cfg.spoolDir}' 0700 ${cfg.user} ${cfg.group} -"
    ];

    security.pam.services.ejabberd = {};

  };

}
