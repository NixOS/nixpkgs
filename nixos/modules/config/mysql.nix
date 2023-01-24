{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.users.mysql;
in
{
  options = {
    users.mysql = {
      enable = mkEnableOption (lib.mdDoc "Authentication against a MySQL/MariaDB database");
      host = mkOption {
        type = types.str;
        example = "localhost";
        description = lib.mdDoc "The hostname of the MySQL/MariaDB server";
      };
      database = mkOption {
        type = types.str;
        example = "auth";
        description = lib.mdDoc "The name of the database containing the users";
      };
      user = mkOption {
        type = types.str;
        example = "nss-user";
        description = lib.mdDoc "The username to use when connecting to the database";
      };
      passwordFile = mkOption {
        type = types.path;
        example = "/run/secrets/mysql-auth-db-passwd";
        description = lib.mdDoc "The path to the file containing the password for the user";
      };
      pam = mkOption {
        description = lib.mdDoc "Settings for `pam_mysql`";
        type = types.submodule {
          options = {
            table = mkOption {
              type = types.str;
              example = "users";
              description = lib.mdDoc "The name of table that maps unique login names to the passwords.";
            };
            updateTable = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "users_updates";
              description = lib.mdDoc ''
                The name of the table used for password alteration. If not defined, the value
                of the `table` option will be used instead.
              '';
            };
            userColumn = mkOption {
              type = types.str;
              example = "username";
              description = lib.mdDoc "The name of the column that contains a unix login name.";
            };
            passwordColumn = mkOption {
              type = types.str;
              example = "password";
              description = lib.mdDoc "The name of the column that contains a (encrypted) password string.";
            };
            statusColumn = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "status";
              description = lib.mdDoc ''
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
            passwordCrypt = mkOption {
              example = "2";
              type = types.enum [
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
              description = lib.mdDoc ''
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
            cryptDefault = mkOption {
              type = types.nullOr (types.enum [ "md5" "sha256" "sha512" "blowfish" ]);
              default = null;
              example = "blowfish";
              description = lib.mdDoc "The default encryption method to use for `passwordCrypt = 1`.";
            };
            where = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "host.name='web' AND user.active=1";
              description = lib.mdDoc "Additional criteria for the query.";
            };
            verbose = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                If enabled, produces logs with detailed messages that describes what
                `pam_mysql` is doing. May be useful for debugging.
              '';
            };
            disconnectEveryOperation = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                By default, `pam_mysql` keeps the connection to the MySQL
                database until the session is closed. If this option is set to true it
                disconnects every time the PAM operation has finished. This option may
                be useful in case the session lasts quite long.
              '';
            };
            logging = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc "Enables logging of authentication attempts in the MySQL database.";
              };
              table = mkOption {
                type = types.str;
                example = "logs";
                description = lib.mdDoc "The name of the table to which logs are written.";
              };
              msgColumn = mkOption {
                type = types.str;
                example = "msg";
                description = lib.mdDoc ''
                  The name of the column in the log table to which the description
                  of the performed operation is stored.
                '';
              };
              userColumn = mkOption {
                type = types.str;
                example = "user";
                description = lib.mdDoc ''
                  The name of the column in the log table to which the name of the
                  user being authenticated is stored.
                '';
              };
              pidColumn = mkOption {
                type = types.str;
                example = "pid";
                description = lib.mdDoc ''
                  The name of the column in the log table to which the pid of the
                  process utilising the `pam_mysql` authentication
                  service is stored.
                '';
              };
              hostColumn = mkOption {
                type = types.str;
                example = "host";
                description = lib.mdDoc ''
                  The name of the column in the log table to which the name of the user
                  being authenticated is stored.
                '';
              };
              rHostColumn = mkOption {
                type = types.str;
                example = "rhost";
                description = lib.mdDoc ''
                  The name of the column in the log table to which the name of the remote
                  host that initiates the session is stored. The value is supposed to be
                  set by the PAM-aware application with `pam_set_item(PAM_RHOST)`.
                '';
              };
              timeColumn = mkOption {
                type = types.str;
                example = "timestamp";
                description = lib.mdDoc ''
                  The name of the column in the log table to which the timestamp of the
                  log entry is stored.
                '';
              };
            };
          };
        };
      };
      nss = mkOption {
        description = lib.mdDoc ''
          Settings for `libnss-mysql`.

          All examples are from the [minimal example](https://github.com/saknopper/libnss-mysql/tree/master/sample/minimal)
          of `libnss-mysql`, but they are modified with NixOS paths for bash.
        '';
        type = types.submodule {
          options = {
            getpwnam = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' \
                FROM users \
                WHERE username='%1$s' \
                LIMIT 1
              '';
              description = lib.mdDoc ''
                SQL query for the [getpwnam](https://man7.org/linux/man-pages/man3/getpwnam.3.html)
                syscall.
              '';
            };
            getpwuid = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' \
                FROM users \
                WHERE uid='%1$u' \
                LIMIT 1
              '';
              description = lib.mdDoc ''
                SQL query for the [getpwuid](https://man7.org/linux/man-pages/man3/getpwuid.3.html)
                syscall.
              '';
            };
            getspnam = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,password,'1','0','99999','0','0','-1','0' \
                FROM users \
                WHERE username='%1$s' \
                LIMIT 1
              '';
              description = lib.mdDoc ''
                SQL query for the [getspnam](https://man7.org/linux/man-pages/man3/getspnam.3.html)
                syscall.
              '';
            };
            getpwent = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' FROM users
              '';
              description = lib.mdDoc ''
                SQL query for the [getpwent](https://man7.org/linux/man-pages/man3/getpwent.3.html)
                syscall.
              '';
            };
            getspent = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,password,'1','0','99999','0','0','-1','0' FROM users
              '';
              description = lib.mdDoc ''
                SQL query for the [getspent](https://man7.org/linux/man-pages/man3/getspent.3.html)
                syscall.
              '';
            };
            getgrnam = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT name,password,gid FROM groups WHERE name='%1$s' LIMIT 1
              '';
              description = lib.mdDoc ''
                SQL query for the [getgrnam](https://man7.org/linux/man-pages/man3/getgrnam.3.html)
                syscall.
              '';
            };
            getgrgid = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT name,password,gid FROM groups WHERE gid='%1$u' LIMIT 1
              '';
              description = lib.mdDoc ''
                SQL query for the [getgrgid](https://man7.org/linux/man-pages/man3/getgrgid.3.html)
                syscall.
              '';
            };
            getgrent = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT name,password,gid FROM groups
              '';
              description = lib.mdDoc ''
                SQL query for the [getgrent](https://man7.org/linux/man-pages/man3/getgrent.3.html)
                syscall.
              '';
            };
            memsbygid = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username FROM grouplist WHERE gid='%1$u'
              '';
              description = lib.mdDoc ''
                SQL query for the [memsbygid](https://man7.org/linux/man-pages/man3/memsbygid.3.html)
                syscall.
              '';
            };
            gidsbymem = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT gid FROM grouplist WHERE username='%1$s'
              '';
              description = lib.mdDoc ''
                SQL query for the [gidsbymem](https://man7.org/linux/man-pages/man3/gidsbymem.3.html)
                syscall.
              '';
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    system.nssModules = [ pkgs.libnss-mysql ];
    system.nssDatabases.shadow = [ "mysql" ];
    system.nssDatabases.group = [ "mysql" ];
    system.nssDatabases.passwd = [ "mysql" ];

    environment.etc."security/pam_mysql.conf" = {
      user = "root";
      group = "root";
      mode = "0600";
      # password will be added from password file in activation script
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
      '' + optionalString (cfg.pam.cryptDefault != null) ''
        users.use_${cfg.pam.cryptDefault}=1
      '' + optionalString (cfg.pam.where != null) ''
        users.where_clause=${cfg.pam.where}
      '' + optionalString (cfg.pam.statusColumn != null) ''
        users.status_column=${cfg.pam.statusColumn}
      '' + optionalString (cfg.pam.updateTable != null) ''
        users.update_table=${cfg.pam.updateTable}
      '' + optionalString cfg.pam.logging.enable ''
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
      text = optionalString (cfg.nss.getpwnam != null) ''
        getpwnam ${cfg.nss.getpwnam}
      '' + optionalString (cfg.nss.getpwuid != null) ''
        getpwuid ${cfg.nss.getpwuid}
      '' + optionalString (cfg.nss.getspnam != null) ''
        getspnam ${cfg.nss.getspnam}
      '' + optionalString (cfg.nss.getpwent != null) ''
        getpwent ${cfg.nss.getpwent}
      '' + optionalString (cfg.nss.getspent != null) ''
        getspent ${cfg.nss.getspent}
      '' + optionalString (cfg.nss.getgrnam != null) ''
        getgrnam ${cfg.nss.getgrnam}
      '' + optionalString (cfg.nss.getgrgid != null) ''
        getgrgid ${cfg.nss.getgrgid}
      '' + optionalString (cfg.nss.getgrent != null) ''
        getgrent ${cfg.nss.getgrent}
      '' + optionalString (cfg.nss.memsbygid != null) ''
        memsbygid ${cfg.nss.memsbygid}
      '' + optionalString (cfg.nss.gidsbymem != null) ''
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
      # password will be added from password file in activation script
      text = ''
        username ${cfg.user}
      '';
    };

    # Activation script to append the password from the password file
    # to the configuration files. It also fixes the owner of the
    # libnss-mysql-root.cfg because it is changed to root after the
    # password is appended.
    system.activationScripts.mysql-auth-passwords = ''
      if [[ -r ${cfg.passwordFile} ]]; then
        org_umask=$(umask)
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

        umask $org_umask
      fi
    '';
  };
}
