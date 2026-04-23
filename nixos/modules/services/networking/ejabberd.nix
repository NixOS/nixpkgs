{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.ejabberd;

  ctlcfg = pkgs.writeText "ejabberdctl.cfg" ''
    ERL_EPMD_ADDRESS=127.0.0.1
    ${cfg.ctlConfig}
  '';

  ectl = ''${cfg.package}/bin/ejabberdctl ${
    lib.optionalString (cfg.configFile != null) "--config ${cfg.configFile}"
  } --ctl-config "${ctlcfg}" --spool "${cfg.spoolDir}" --logs "${cfg.logsDir}"'';

  dumps = lib.escapeShellArgs cfg.loadDumps;

in
{

  ###### interface

  options = {

    services.ejabberd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable ejabberd server";
      };

      package = lib.mkPackageOption pkgs "ejabberd" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ejabberd";
        description = "User under which ejabberd is ran";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "ejabberd";
        description = "Group under which ejabberd is ran";
      };

      spoolDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/ejabberd";
        description = "Location of the spooldir of ejabberd";
      };

      logsDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/ejabberd";
        description = "Location of the logfile directory of ejabberd";
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = "Configuration file for ejabberd in YAML format";
        default = null;
      };

      ctlConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Configuration of ejabberdctl";
      };

      loadDumps = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = "Configuration dumps that should be loaded on the first startup";
        example = lib.literalExpression "[ ./myejabberd.dump ]";
      };

      imagemagick = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Add ImageMagick to server's path; allows for image thumbnailing";
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users = lib.optionalAttrs (cfg.user == "ejabberd") {
      ejabberd = {
        group = cfg.group;
        home = cfg.spoolDir;
        createHome = true;
        uid = config.ids.uids.ejabberd;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "ejabberd") {
      ejabberd.gid = config.ids.gids.ejabberd;
    };

    systemd.services.ejabberd = {
      description = "ejabberd server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [
        pkgs.findutils
        pkgs.coreutils
      ]
      ++ lib.optional cfg.imagemagick pkgs.imagemagick;

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

        if ! test -e ${cfg.spoolDir}/.erlang.cookie; then
          touch ${cfg.spoolDir}/.erlang.cookie
          chmod 600 ${cfg.spoolDir}/.erlang.cookie
          dd if=/dev/random bs=16 count=1 | base64 > ${cfg.spoolDir}/.erlang.cookie
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

    security.pam.services.ejabberd = { };

  };

}
