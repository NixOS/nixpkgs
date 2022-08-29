{ config, lib, pkgs, ... }:

let

  inherit (lib) concatMapStringsSep concatStringsSep isInt isList literalExpression;
  inherit (lib) mapAttrs mapAttrsToList mkDefault mkEnableOption mkIf mkOption optional types;

  cfg = config.services.automysqlbackup;
  pkg = pkgs.automysqlbackup;
  user = "automysqlbackup";
  group = "automysqlbackup";

  toStr = val:
    if isList val then "( ${concatMapStringsSep " " (val: "'${val}'") val} )"
    else if isInt val then toString val
    else if true == val then "'yes'"
    else if false == val then "'no'"
    else "'${toString val}'";

  configFile = pkgs.writeText "automysqlbackup.conf" ''
    #version=${pkg.version}
    # DONT'T REMOVE THE PREVIOUS VERSION LINE!
    #
    ${concatStringsSep "\n" (mapAttrsToList (name: value: "CONFIG_${name}=${toStr value}") cfg.config)}
  '';

in
{
  # interface
  options = {
    services.automysqlbackup = {

      enable = mkEnableOption "AutoMySQLBackup";

      calendar = mkOption {
        type = types.str;
        default = "01:15:00";
        description = lib.mdDoc ''
          Configured when to run the backup service systemd unit (DayOfWeek Year-Month-Day Hour:Minute:Second).
        '';
      };

      config = mkOption {
        type = with types; attrsOf (oneOf [ str int bool (listOf str) ]);
        default = {};
        description = lib.mdDoc ''
          automysqlbackup configuration. Refer to
          {file}`''${pkgs.automysqlbackup}/etc/automysqlbackup.conf`
          for details on supported values.
        '';
        example = literalExpression ''
          {
            db_names = [ "nextcloud" "matomo" ];
            table_exclude = [ "nextcloud.oc_users" "nextcloud.oc_whats_new" ];
            mailcontent = "log";
            mail_address = "admin@example.org";
          }
        '';
      };

    };
  };

  # implementation
  config = mkIf cfg.enable {

    assertions = [
      { assertion = !config.services.mysqlBackup.enable;
        message = "Please choose one of services.mysqlBackup or services.automysqlbackup.";
      }
    ];

    services.automysqlbackup.config = mapAttrs (name: mkDefault) {
      mysql_dump_username = user;
      mysql_dump_host = "localhost";
      mysql_dump_socket = "/run/mysqld/mysqld.sock";
      backup_dir = "/var/backup/mysql";
      db_exclude = [ "information_schema" "performance_schema" ];
      mailcontent = "stdout";
      mysql_dump_single_transaction = true;
    };

    systemd.timers.automysqlbackup = {
      description = "automysqlbackup timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.calendar;
        AccuracySec = "5m";
      };
    };

    systemd.services.automysqlbackup = {
      description = "automysqlbackup service";
      serviceConfig = {
        User = user;
        Group = group;
        ExecStart = "${pkg}/bin/automysqlbackup ${configFile}";
      };
    };

    environment.systemPackages = [ pkg ];

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };
    users.groups.${group} = { };

    systemd.tmpfiles.rules = [
      "d '${cfg.config.backup_dir}' 0750 ${user} ${group} - -"
    ];

    services.mysql.ensureUsers = optional (config.services.mysql.enable && cfg.config.mysql_dump_host == "localhost") {
      name = user;
      ensurePermissions = { "*.*" = "SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT"; };
    };

  };
}
