{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.users.mysql;
in
{
  options = {
    users.mysql = {
      enable = mkEnableOption "Authentication against a MySQL/MariaDB database";
      host = mkOption {
        type = types.str;
        example = "localhost";
        description = "The hostname of the MySQL/MariaDB server";
      };
      database = mkOption {
        type = types.str;
        example = "auth";
        description = "The name of the database containing the users";
      };
      user = mkOption {
        type = types.str;
        example = "nss-user";
        description = "The username to use when connecting to the database";
      };
      passwordFile = mkOption {
        type = types.path;
        example = "/run/secrets/mysql-auth-db-passwd";
        description = "The path to the file containing the password for the user";
      };
      pam = mkOption {
        description = "Settings for <literal>pam_mysql</literal>";
        type = types.submodule {
          options = {
            table = mkOption {
              type = types.str;
              example = "users";
              description = "The name of table that maps unique login names to the passwords.";
            };
            updateTable = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "users_updates";
              description = ''
                The name of the table used for password alteration. If not defined, the value
                of the <literal>table</literal> option will be used instead.
              '';
            };
            userColumn = mkOption {
              type = types.str;
              example = "username";
              description = "The name of the column that contains a unix login name.";
            };
            passwordColumn = mkOption {
              type = types.str;
              example = "password";
              description = "The name of the column that contains a (encrypted) password string.";
            };
            statusColumn = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "status";
              description = ''
                The name of the column or an SQL expression that indicates the status of
                the user. The status is expressed by the combination of two bitfields
                shown below:

                <itemizedlist>
                  <listitem>
                    <para>
                      <literal>bit 0 (0x01)</literal>:
                      if flagged, <literal>pam_mysql</literal> deems the account to be expired and
                      returns <literal>PAM_ACCT_EXPIRED</literal>. That is, the account is supposed
                      to no longer be available. Note this doesn't mean that <literal>pam_mysql</literal>
                      rejects further authentication operations.
                    </para>
                  </listitem>
                  <listitem>
                    <para>
                      <literal>bit 1 (0x02)</literal>:
                      if flagged, <literal>pam_mysql</literal> deems the authentication token
                      (password) to be expired and returns <literal>PAM_NEW_AUTHTOK_REQD</literal>.
                      This ends up requiring that the user enter a new password.
                    </para>
                  </listitem>
                </itemizedlist>
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
              description = ''
                The method to encrypt the user's password:

                <itemizedlist>
                <listitem>
                  <para>
                    <literal>0</literal> (or <literal>"plain"</literal>):
                    No encryption. Passwords are stored in plaintext. HIGHLY DISCOURAGED.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>1</literal> (or <literal>"Y"</literal>):
                    Use crypt(3) function.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>2</literal> (or <literal>"mysql"</literal>):
                    Use the MySQL PASSWORD() function. It is possible that the encryption function used
                    by <literal>pam_mysql</literal> is different from that of the MySQL server, as
                    <literal>pam_mysql</literal> uses the function defined in MySQL's C-client API
                    instead of using PASSWORD() SQL function in the query.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>3</literal> (or <literal>"md5"</literal>):
                    Use plain hex MD5.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>4</literal> (or <literal>"sha1"</literal>):
                    Use plain hex SHA1.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>5</literal> (or <literal>"drupal7"</literal>):
                    Use Drupal7 salted passwords.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>6</literal> (or <literal>"joomla15"</literal>):
                    Use Joomla15 salted passwords.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>7</literal> (or <literal>"ssha"</literal>):
                    Use ssha hashed passwords.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>8</literal> (or <literal>"sha512"</literal>):
                    Use sha512 hashed passwords.
                  </para>
                </listitem>
                <listitem>
                  <para>
                    <literal>9</literal> (or <literal>"sha256"</literal>):
                    Use sha256 hashed passwords.
                  </para>
                </listitem>
                </itemizedlist>
              '';
            };
            cryptDefault = mkOption {
              type = types.nullOr (types.enum [ "md5" "sha256" "sha512" "blowfish" ]);
              default = null;
              example = "blowfish";
              description = "The default encryption method to use for <literal>passwordCrypt = 1</literal>.";
            };
            where = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "host.name='web' AND user.active=1";
              description = "Additional criteria for the query.";
            };
            verbose = mkOption {
              type = types.bool;
              default = false;
              description = ''
                If enabled, produces logs with detailed messages that describes what
                <literal>pam_mysql</literal> is doing. May be useful for debugging.
              '';
            };
            disconnectEveryOperation = mkOption {
              type = types.bool;
              default = false;
              description = ''
                By default, <literal>pam_mysql</literal> keeps the connection to the MySQL
                database until the session is closed. If this option is set to true it
                disconnects every time the PAM operation has finished. This option may
                be useful in case the session lasts quite long.
              '';
            };
            logging = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enables logging of authentication attempts in the MySQL database.";
              };
              table = mkOption {
                type = types.str;
                example = "logs";
                description = "The name of the table to which logs are written.";
              };
              msgColumn = mkOption {
                type = types.str;
                example = "msg";
                description = ''
                  The name of the column in the log table to which the description
                  of the performed operation is stored.
                '';
              };
              userColumn = mkOption {
                type = types.str;
                example = "user";
                description = ''
                  The name of the column in the log table to which the name of the
                  user being authenticated is stored.
                '';
              };
              pidColumn = mkOption {
                type = types.str;
                example = "pid";
                description = ''
                  The name of the column in the log table to which the pid of the
                  process utilising the <literal>pam_mysql's</literal> authentication
                  service is stored.
                '';
              };
              hostColumn = mkOption {
                type = types.str;
                example = "host";
                description = ''
                  The name of the column in the log table to which the name of the user
                  being authenticated is stored.
                '';
              };
              rHostColumn = mkOption {
                type = types.str;
                example = "rhost";
                description = ''
                  The name of the column in the log table to which the name of the remote
                  host that initiates the session is stored. The value is supposed to be
                  set by the PAM-aware application with <literal>pam_set_item(PAM_RHOST)
                  </literal>.
                '';
              };
              timeColumn = mkOption {
                type = types.str;
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
      nss = mkOption {
        description = ''
          Settings for <literal>libnss-mysql</literal>.

          All examples are from the <link xlink:href="https://github.com/saknopper/libnss-mysql/tree/master/sample/minimal">minimal example</link>
          of <literal>libnss-mysql</literal>, but they are modified with NixOS paths for bash.
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
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getpwnam.3.html">getpwnam</link>
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
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getpwuid.3.html">getpwuid</link>
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
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getspnam.3.html">getspnam</link>
                syscall.
              '';
            };
            getpwent = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,'x',uid,'5000','MySQL User', CONCAT('/home/',username),'/run/sw/current-system/bin/bash' FROM users
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getpwent.3.html">getpwent</link>
                syscall.
              '';
            };
            getspent = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username,password,'1','0','99999','0','0','-1','0' FROM users
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getspent.3.html">getspent</link>
                syscall.
              '';
            };
            getgrnam = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT name,password,gid FROM groups WHERE name='%1$s' LIMIT 1
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getgrnam.3.html">getgrnam</link>
                syscall.
              '';
            };
            getgrgid = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT name,password,gid FROM groups WHERE gid='%1$u' LIMIT 1
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getgrgid.3.html">getgrgid</link>
                syscall.
              '';
            };
            getgrent = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT name,password,gid FROM groups
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/getgrent.3.html">getgrent</link>
                syscall.
              '';
            };
            memsbygid = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT username FROM grouplist WHERE gid='%1$u'
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/memsbygid.3.html">memsbygid</link>
                syscall.
              '';
            };
            gidsbymem = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = literalExpression ''
                SELECT gid FROM grouplist WHERE username='%1$s'
              '';
              description = ''
                SQL query for the <link
                xlink:href="https://man7.org/linux/man-pages/man3/gidsbymem.3.html">gidsbymem</link>
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
