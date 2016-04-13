{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.ejabberd;

  ctlcfg = pkgs.writeText "ejabberdctl.cfg" ''
    ERL_EPMD_ADDRESS=127.0.0.1
    ${cfg.ctlConfig}
  '';

  ectl = ''${cfg.package}/bin/ejabberdctl ${if cfg.configFile == null then "" else "--config ${cfg.configFile}"} --ctl-config "${ctlcfg}" --spool "${cfg.spoolDir}" --logs "${cfg.logsDir}"'';

  dumps = lib.concatMapStringsSep " " lib.escapeShellArg cfg.loadDumps;

in {

  ###### interface

  options = {

    services.ejabberd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable ejabberd server";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ejabberd;
        defaultText = "pkgs.ejabberd";
        description = "ejabberd server package to use";
      };

      user = mkOption {
        type = types.str;
        default = "ejabberd";
        description = "User under which ejabberd is ran";
      };

      group = mkOption {
        type = types.str;
        default = "ejabberd";
        description = "Group under which ejabberd is ran";
      };

      spoolDir = mkOption {
        type = types.path;
        default = "/var/lib/ejabberd";
        description = "Location of the spooldir of ejabberd";
      };

      logsDir = mkOption {
        type = types.path;
        default = "/var/log/ejabberd";
        description = "Location of the logfile directory of ejabberd";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        description = "Configuration file for ejabberd in YAML format";
        default = null;
      };

      ctlConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration of ejabberdctl";
      };

      loadDumps = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "Configuration dumps that should be loaded on the first startup";
        example = literalExample "[ ./myejabberd.dump ]";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.extraUsers = optionalAttrs (cfg.user == "ejabberd") (singleton
      { name = "ejabberd";
        group = cfg.group;
        home = cfg.spoolDir;
        createHome = true;
        uid = config.ids.uids.ejabberd;
      });

    users.extraGroups = optionalAttrs (cfg.group == "ejabberd") (singleton
      { name = "ejabberd";
        gid = config.ids.gids.ejabberd;
      });

    systemd.services.ejabberd = {
      description = "ejabberd server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.findutils pkgs.coreutils ];

      serviceConfig = {
        Type = "forking";
        # FIXME: runit is used for `chpst` -- can we get rid of this?
        ExecStop = ''${pkgs.runit}/bin/chpst -u "${cfg.user}:${cfg.group}" ${ectl} stop'';
        ExecReload = ''${pkgs.runit}/bin/chpst -u "${cfg.user}:${cfg.group}" ${ectl} reload_config'';
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -p -m750 "${cfg.logsDir}"
        chown "${cfg.user}:${cfg.group}" "${cfg.logsDir}"

        mkdir -p -m750 "/var/lock/ejabberdctl"
        chown "${cfg.user}:${cfg.group}" "/var/lock/ejabberdctl"

        mkdir -p -m750 "${cfg.spoolDir}"
        chown -R "${cfg.user}:${cfg.group}" "${cfg.spoolDir}"
      '';

      script = ''
        [ -z "$(ls -A '${cfg.spoolDir}')" ] && firstRun=1

        ${ectl} start

        count=0
        while ! ${ectl} status >/dev/null 2>&1; do
          if [ $count -eq 30 ]; then
            echo "ejabberd server hasn't started in 30 seconds, giving up"
            exit 1
          fi

          count=$((count++))
          sleep 1
        done

        if [ -n "$firstRun" ]; then
          for src in ${dumps}; do
            find "$src" -type f | while read dump; do
              echo "Loading configuration dump at $dump"
              ${ectl} load "$dump"
            done
          done
        fi
      '';
    };

    security.pam.services.ejabberd = {};

  };

}
