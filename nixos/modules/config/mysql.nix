{ config, pkgs, lib, ... }:
let
  cfg = config.users.mysql;
in
{
  meta.maintainers = [ lib.maintainers.netali ];

  options = {
    users.mysql = {
      enable = lib.mkEnableOption "authentication against a MySQL/MariaDB database";
      host = lib.mkOption {
        type = lib.types.str;
        example = "localhost";
        description = "The hostname of the MySQL/MariaDB server";
      };
      database = lib.mkOption {
        type = lib.types.str;
        example = "auth";
        description = "The name of the database containing the users";
      };
      user = lib.mkOption {
        type = lib.types.str;
        example = "nss-user";
        description = "The username to use when connecting to the database";
      };
      passwordFile = lib.mkOption {
        type = lib.types.path;
        example = "/run/secrets/mysql-auth-db-passwd";
        description = "The path to the file containing the password for the user";
      };
      pam = lib.mkOption {
        description = "Settings for `pam_mysql`";
        type = lib.types.submodule {
          options = {
            table = lib.mkOption {
              type = lib.types.str;
              example = "users";
              description = "The name of table that maps unique login names to the passwords.";
            };
            updateTable = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "users_updates";
              description = ''
                The name of the table used for password alteration. If not defined, the value
                of the `table` option will be used instead.
              '';
            };
            userColumn = lib.mkOption {
              type = lib.types.str;
              example = "username";
              description = "The name of the column that contains a unix login name.";
            };
            passwordColumn = lib.mkOption {
              type = lib.types.str;
              example = "password";
              description = "The name of the column that contains a (encrypted) password string.";
            };
            statusColumn = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "status";
              description = ''
                The name of the column or an SQL expression that indicates the status of
                the user. The status is expressed by the combination of two bitfields
                shown below:

                - `bit 0 (0x01)`:
                   if flagged, `pam_mysql` deems the account to be expired and
                   returns `PAM_ACCT_EXPIRED`. That is, the account is supposed
                   to no longer be available. Note this doesn't mean that `pam_mysql`
                   rejects further authentication operations.
                -  `bit 1 (0x02)`:
                   if flagged, `pam_mysql` deems the authentication token
                   (password) to be expired and returns `PAM_NEW_AUTHTOK_REQD`.
                   This ends up requiring that the user enter a new password.
              '';
            };
            passwordCrypt = lib.mkOption {
              example = "2";
              type = lib.types.enum [
                "0" "plain"
                "1" "Y"
                "2" "mysql"
                "3" "md5"
                "4" "sha1"
                "5" "drupal7"
                "6" "joomla15"
                "7" "ssha"
                "8" "sha512"
                "9" "sha256"
              ];
              description = ''
                The method to encrypt the user's password:

                - `0` (or `"plain"`):
                  No encryption. Passwords are stored in plaintext. HIGHLY DISCOURAGED.
                - `1` (or `"Y"`):
                  Use crypt(3) function.
                - `2` (or `"mysql"`):
                  Use the MySQL PASSWORD() function. It is possible that the encryption function used
                  by `pam_mysql` is different from that of the MySQL server, as
                  `pam_mysql` uses the function defined in MySQL's C-client API
                  instead of using PASSWORD() SQL function in the query.
                - `3` (or `"md5"`):
                  Use plain hex MD5.
                - `4` (or `"sha1"`):
                  Use plain hex SHA1.
                - `5` (or `"drupal7"`):
                  Use Drupal7 salted passwords.
                - `6` (or `"joomla15"`):
                  Use Joomla15 salted passwords.
                - `7` (or `"ssha"`):
                  Use ssha hashed passwords.
                - `8` (or `"sha512"`):
                  Use sha512 hashed passwords.
                - `9` (or `"sha256"`):
                  Use sha256 hashed passwords.
              '';
            };
            cryptDefault = lib.mkOption {
              type = lib.types.nullOr (lib.types.enum [ "md5" "sha256" "sha512" "blowfish" ]);
              default = null;
              example = "blowfish";
              description = "The default encryption method to use for `passwordCrypt = 1`.";
            };
            where = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "host.name='web' AND user.active=1";
              description = "Additional criteria for the query.";
            };
            verbose = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                If enabled, produces logs with detailed messages that describes what
                `pam_mysql` is doing. May be useful for debugging.
              '';
            };
            disconnectEveryOperation = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                By default, `pam_mysql` keeps the connection to the MySQL
                database until the session is closed. If this option is set to true it
                disconnects every time the PAM operation has finished. This option may
                be useful in case the session lasts quite long.
              '';
            };
            logging = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enables logging of authentication attempts in the MySQL database.";
              };
              table = lib.mkOption {
                type = lib.types.str;
                example = "logs";
                description = "The name of the table to which logs are written.";
              };
              msgColumn = lib.mkOption {
                type = lib.types.str;
                example = "msg";
                description = ''
                  The name of the column in the log table to which the description
                  of the performed operation is stored.
                '';
              };
              userColumn = lib.mkOption {
                type = lib.types.str;
                example = "user";
                description = ''
                  The name of the column in the log table to which the name of the
                  user being authenticated is stored.
                '';
              };
              pidColumn = lib.mkOption {
                type = lib.types.str;
                example = "pid";
                description = ''
                  The name of the column in the log table to which the pid of the
                  process utilising the `pam_mysql` authentication
                  service is stored.
                '';
              };
              hostColumn = lib.mkOption {
                type = lib.types.str;
                example = "host";
                description = ''
                  The name of the column in the log table to which the name of the user
                  being authenticated is stored.
                '';
              };
              rHostColumn = lib.mkOption {
                type = lib.types.str;
                example = "rhost";
                description = ''
                  The name of the column in the log table to which the name of the remote
                  host that initiates the session is stored. The value is supposed to be
                  set by the PAM-aware application with `pam_set_item(PAM_RHOST)`.
                '';
              };
              timeColumn = lib.mkOption {
                type = lib.types.str;
                example = "timestamp";
                description = ''
                  The name of the column in the log table to which the timestamp of the
                  log entry is stored.
                '';
              };
            };
          };
        };
      };
      nss = lib.mkOption {
        description = ''
          Settings for `libnss-mysql`.

          All examples are from the [minimal example](https://github.com/saknopper/libnss-mysql/tree/master/sample/minimal)
          of `libnss-mysql`, but they are modified with NixOS paths for bash.
        '';
        type = lib.types.submodule {
          options = {
            getpwnam = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' \
                FROM users \
                WHERE username='%1$s' \
                LIMIT 1
              '';
              description = ''
                SQL query for the [getpwnam](https://man7.org/linux/man-pages/man3/getpwnam.3.html)
                syscall.
              '';
            };
            getpwuid = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' \
                FROM users \
                WHERE uid='%1$u' \
                LIMIT 1
              '';
              description = ''
                SQL query for the [getpwuid](https://man7.org/linux/man-pages/man3/getpwuid.3.html)
                syscall.
              '';
            };
            getspnam = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT username,password,'1','0','99999','0','0','-1','0' \
                FROM users \
                WHERE username='%1$s' \
                LIMIT 1
              '';
              description = ''
                SQL query for the [getspnam](https://man7.org/linux/man-pages/man3/getspnam.3.html)
                syscall.
              '';
            };
            getpwent = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' FROM users
              '';
              description = ''
                SQL query for the [getpwent](https://man7.org/linux/man-pages/man3/getpwent.3.html)
                syscall.
              '';
            };
            getspent = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT username,password,'1','0','99999','0','0','-1','0' FROM users
              '';
              description = ''
                SQL query for the [getspent](https://man7.org/linux/man-pages/man3/getspent.3.html)
                syscall.
              '';
            };
            getgrnam = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT name,password,gid FROM groups WHERE name='%1$s' LIMIT 1
              '';
              description = ''
                SQL query for the [getgrnam](https://man7.org/linux/man-pages/man3/getgrnam.3.html)
                syscall.
              '';
            };
            getgrgid = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT name,password,gid FROM groups WHERE gid='%1$u' LIMIT 1
              '';
              description = ''
                SQL query for the [getgrgid](https://man7.org/linux/man-pages/man3/getgrgid.3.html)
                syscall.
              '';
            };
            getgrent = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT name,password,gid FROM groups
              '';
              description = ''
                SQL query for the [getgrent](https://man7.org/linux/man-pages/man3/getgrent.3.html)
                syscall.
              '';
            };
            memsbygid = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT username FROM grouplist WHERE gid='%1$u'
              '';
              description = ''
                SQL query for the [memsbygid](https://man7.org/linux/man-pages/man3/memsbygid.3.html)
                syscall.
              '';
            };
            gidsbymem = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = lib.literalExpression ''
                SELECT gid FROM grouplist WHERE username='%1$s'
              '';
              description = ''
                SQL query for the [gidsbymem](https://man7.org/linux/man-pages/man3/gidsbymem.3.html)
                syscall.
              '';
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system.nssModules = [ pkgs.libnss-mysql ];
    system.nssDatabases.shadow = [ "mysql" ];
    system.nssDatabases.group = [ "mysql" ];
    system.nssDatabases.passwd = [ "mysql" ];

    environment.etc."security/pam_mysql.conf" = {
      user = "root";
      group = "root";
      mode = "0600";
      # password will be added from password file in systemd oneshot
      text = ''
        users.host=${cfg.host}
        users.db_user=${cfg.user}
        users.database=${cfg.database}
        users.table=${cfg.pam.table}
        users.user_column=${cfg.pam.userColumn}
        users.password_column=${cfg.pam.passwordColumn}
        users.password_crypt=${cfg.pam.passwordCrypt}
        users.disconnect_every_operation=${if cfg.pam.disconnectEveryOperation then "1" else "0"}
        verbose=${if cfg.pam.verbose then "1" else "0"}
      '' + lib.optionalString (cfg.pam.cryptDefault != null) ''
        users.use_${cfg.pam.cryptDefault}=1
      '' + lib.optionalString (cfg.pam.where != null) ''
        users.where_clause=${cfg.pam.where}
      '' + lib.optionalString (cfg.pam.statusColumn != null) ''
        users.status_column=${cfg.pam.statusColumn}
      '' + lib.optionalString (cfg.pam.updateTable != null) ''
        users.update_table=${cfg.pam.updateTable}
      '' + lib.optionalString cfg.pam.logging.enable ''
        log.enabled=true
        log.table=${cfg.pam.logging.table}
        log.message_column=${cfg.pam.logging.msgColumn}
        log.pid_column=${cfg.pam.logging.pidColumn}
        log.user_column=${cfg.pam.logging.userColumn}
        log.host_column=${cfg.pam.logging.hostColumn}
        log.rhost_column=${cfg.pam.logging.rHostColumn}
        log.time_column=${cfg.pam.logging.timeColumn}
      '';
    };

    environment.etc."libnss-mysql.cfg" = {
      mode = "0600";
      user = config.services.nscd.user;
      group = config.services.nscd.group;
      text = lib.optionalString (cfg.nss.getpwnam != null) ''
        getpwnam ${cfg.nss.getpwnam}
      '' + lib.optionalString (cfg.nss.getpwuid != null) ''
        getpwuid ${cfg.nss.getpwuid}
      '' + lib.optionalString (cfg.nss.getspnam != null) ''
        getspnam ${cfg.nss.getspnam}
      '' + lib.optionalString (cfg.nss.getpwent != null) ''
        getpwent ${cfg.nss.getpwent}
      '' + lib.optionalString (cfg.nss.getspent != null) ''
        getspent ${cfg.nss.getspent}
      '' + lib.optionalString (cfg.nss.getgrnam != null) ''
        getgrnam ${cfg.nss.getgrnam}
      '' + lib.optionalString (cfg.nss.getgrgid != null) ''
        getgrgid ${cfg.nss.getgrgid}
      '' + lib.optionalString (cfg.nss.getgrent != null) ''
        getgrent ${cfg.nss.getgrent}
      '' + lib.optionalString (cfg.nss.memsbygid != null) ''
        memsbygid ${cfg.nss.memsbygid}
      '' + lib.optionalString (cfg.nss.gidsbymem != null) ''
        gidsbymem ${cfg.nss.gidsbymem}
      '' + ''
        host ${cfg.host}
        database ${cfg.database}
      '';
    };

    environment.etc."libnss-mysql-root.cfg" = {
      mode = "0600";
      user = config.services.nscd.user;
      group = config.services.nscd.group;
      # password will be added from password file in systemd oneshot
      text = ''
        username ${cfg.user}
      '';
    };

    systemd.services.mysql-auth-pw-init = {
      description = "Adds the mysql password to the mysql auth config files";

      before = [ "nscd.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        Group = "root";
      };

      restartTriggers = [
        config.environment.etc."security/pam_mysql.conf".source
        config.environment.etc."libnss-mysql.cfg".source
        config.environment.etc."libnss-mysql-root.cfg".source
      ];

      script = ''
        if [[ -r ${cfg.passwordFile} ]]; then
          umask 0077
          conf_nss="$(mktemp)"
          cp /etc/libnss-mysql-root.cfg $conf_nss
          printf 'password %s\n' "$(cat ${cfg.passwordFile})" >> $conf_nss
          mv -fT "$conf_nss" /etc/libnss-mysql-root.cfg
          chown ${config.services.nscd.user}:${config.services.nscd.group} /etc/libnss-mysql-root.cfg

          conf_pam="$(mktemp)"
          cp /etc/security/pam_mysql.conf $conf_pam
          printf 'users.db_passwd=%s\n' "$(cat ${cfg.passwordFile})" >> $conf_pam
          mv -fT "$conf_pam" /etc/security/pam_mysql.conf
        fi
      '';
    };
  };
}
