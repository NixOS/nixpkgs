{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.automysqlbackup;
  pkg = pkgs.automysqlbackup;
  user = "automysqlbackup";
  group = "automysqlbackup";

  toStr =
    val:
    if lib.isList val then
      "( ${lib.concatMapStringsSep " " (val: "'${val}'") val} )"
    else if lib.isInt val then
      toString val
    else if true == val then
      "'yes'"
    else if false == val then
      "'no'"
    else
      "'${toString val}'";

  configFile = pkgs.writeText "automysqlbackup.conf" ''
    #version=${pkg.version}
    # DONT'T REMOVE THE PREVIOUS VERSION LINE!
    #
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "CONFIG_${name}=${toStr value}") cfg.config)}
  '';

in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "automysqlbackup" "config" ]
      [ "services" "automysqlbackup" "settings" ]
    )
  ];

  # interface
  options = {
    services.automysqlbackup = {

      enable = lib.mkEnableOption "AutoMySQLBackup";

      calendar = lib.mkOption {
        type = lib.types.str;
        default = "01:15:00";
        description = ''
          Configured when to run the backup service systemd unit (DayOfWeek Year-Month-Day Hour:Minute:Second).
        '';
      };

      settings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            bool
            (listOf str)
          ]);
        default = { };
        description = ''
          automysqlbackup configuration. Refer to
          {file}`''${pkgs.automysqlbackup}/etc/automysqlbackup.conf`
          for details on supported values.
        '';
        example = lib.literalExpression ''
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
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !config.services.mysqlBackup.enable;
        message = "Please choose one of services.mysqlBackup or services.automysqlbackup.";
      }
    ];

    services.automysqlbackup.config = lib.mapAttrs (name: lib.mkDefault) {
      mysql_dump_username = user;
      mysql_dump_host = "localhost";
      mysql_dump_socket = "/run/mysqld/mysqld.sock";
      backup_dir = "/var/backup/mysql";
      db_exclude = [
        "information_schema"
        "performance_schema"
      ];
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

    services.mysql.ensureUsers =
      lib.optional (config.services.mysql.enable && cfg.config.mysql_dump_host == "localhost")
        {
          name = user;
          ensurePermissions = {
            "*.*" = "SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT";
          };
        };

  };
}
