{ pkgs, lib, ... }:

let
  dbUser = "nixos_auth";
  dbPassword = "topsecret123";
  dbName = "auth";

  mysqlUsername = "mysqltest";
  mysqlPassword = "topsecretmysqluserpassword123";
  mysqlGroup = "mysqlusers";

  localUsername = "localtest";
  localPassword = "topsecretlocaluserpassword123";

  mysqlInit = pkgs.writeText "mysqlInit" ''
    CREATE USER '${dbUser}'@'localhost' IDENTIFIED BY '${dbPassword}';
    CREATE DATABASE ${dbName};
    GRANT ALL PRIVILEGES ON ${dbName}.* TO '${dbUser}'@'localhost';
    FLUSH PRIVILEGES;

    USE ${dbName};
    CREATE TABLE `groups` (
      rowid int(11) NOT NULL auto_increment,
      gid int(11) NOT NULL,
      name char(255) NOT NULL,
      PRIMARY KEY (rowid)
    );

    CREATE TABLE `users` (
      name varchar(255) NOT NULL,
      uid int(11) NOT NULL auto_increment,
      gid int(11) NOT NULL,
      password varchar(255) NOT NULL,
      PRIMARY KEY (uid),
      UNIQUE (name)
    ) AUTO_INCREMENT=5000;

    INSERT INTO `users` (name, uid, gid, password) VALUES
    ('${mysqlUsername}', 5000, 5000, SHA2('${mysqlPassword}', 256));
    INSERT INTO `groups` (name, gid) VALUES ('${mysqlGroup}', 5000);
  '';
in
{
  name = "auth-mysql";
  meta.maintainers = with lib.maintainers; [ netali ];

  nodes.machine =
    { ... }:
    {
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        settings.mysqld.bind-address = "127.0.0.1";
        initialScript = mysqlInit;
      };

      users.users.${localUsername} = {
        isNormalUser = true;
        password = localPassword;
      };

      security.pam.services.login.makeHomeDir = true;

      users.mysql = {
        enable = true;
        host = "127.0.0.1";
        user = dbUser;
        database = dbName;
        passwordFile = "${builtins.toFile "dbPassword" dbPassword}";
        pam = {
          table = "users";
          userColumn = "name";
          passwordColumn = "password";
          passwordCrypt = "sha256";
          disconnectEveryOperation = true;
        };
        nss = {
          getpwnam = ''
            SELECT name, 'x', uid, gid, name, CONCAT('/home/', name), "/run/current-system/sw/bin/bash" \
            FROM users \
            WHERE name='%1$s' \
            LIMIT 1
          '';
          getpwuid = ''
            SELECT name, 'x', uid, gid, name, CONCAT('/home/', name), "/run/current-system/sw/bin/bash" \
            FROM users \
            WHERE uid=%1$u \
            LIMIT 1
          '';
          getspnam = ''
            SELECT name, password, 1, 0, 99999, 7, 0, -1, 0 \
            FROM users \
            WHERE name='%1$s' \
            LIMIT 1
          '';
          getpwent = ''
            SELECT name, 'x', uid, gid, name, CONCAT('/home/', name), "/run/current-system/sw/bin/bash" \
            FROM users
          '';
          getspent = ''
            SELECT name, password, 1, 0, 99999, 7, 0, -1, 0 \
            FROM users
          '';
          getgrnam = ''
            SELECT name, 'x', gid FROM groups WHERE name='%1$s' LIMIT 1
          '';
          getgrgid = ''
            SELECT name, 'x', gid FROM groups WHERE gid='%1$u' LIMIT 1
          '';
          getgrent = ''
            SELECT name, 'x', gid FROM groups
          '';
          memsbygid = ''
            SELECT name FROM users WHERE gid=%1$u
          '';
          gidsbymem = ''
            SELECT gid FROM users WHERE name='%1$s'
          '';
        };
      };
    };

  testScript = ''
    def switch_to_tty(tty_number):
        machine.fail(f"pgrep -f 'agetty.*tty{tty_number}'")
        machine.send_key(f"alt-f{tty_number}")
        machine.wait_until_succeeds(f"[ $(fgconsole) = {tty_number} ]")
        machine.wait_for_unit(f"getty@tty{tty_number}.service")
        machine.wait_until_succeeds(f"pgrep -f 'agetty.*tty{tty_number}'")


    def try_login(tty_number, username, password):
        machine.wait_until_tty_matches(tty_number, "login: ")
        machine.send_chars(f"{username}\n")
        machine.wait_until_tty_matches(tty_number, f"login: {username}")
        machine.wait_until_succeeds("pgrep login")
        machine.wait_until_tty_matches(tty_number, "Password: ")
        machine.send_chars(f"{password}\n")


    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("mysql.service")
    machine.wait_until_succeeds("cat /etc/security/pam_mysql.conf | grep users.db_passwd")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    with subtest("Local login"):
        switch_to_tty("2")
        try_login("2", "${localUsername}", "${localPassword}")

        machine.wait_until_succeeds("pgrep -u ${localUsername} bash")
        machine.send_chars("id > local_id.txt\n")
        machine.wait_for_file("/home/${localUsername}/local_id.txt")
        machine.succeed("cat /home/${localUsername}/local_id.txt | grep 'uid=1000(${localUsername}) gid=100(users) groups=100(users)'")

    with subtest("Local incorrect login"):
        switch_to_tty("3")
        try_login("3", "${localUsername}", "wrongpassword")

        machine.wait_until_tty_matches("3", "Login incorrect")
        machine.wait_until_tty_matches("3", "login:")

    with subtest("MySQL login"):
        switch_to_tty("4")
        try_login("4", "${mysqlUsername}", "${mysqlPassword}")

        machine.wait_until_succeeds("pgrep -u ${mysqlUsername} bash")
        machine.send_chars("id > mysql_id.txt\n")
        machine.wait_for_file("/home/${mysqlUsername}/mysql_id.txt")
        machine.succeed("cat /home/${mysqlUsername}/mysql_id.txt | grep 'uid=5000(${mysqlUsername}) gid=5000(${mysqlGroup}) groups=5000(${mysqlGroup})'")

    with subtest("MySQL incorrect login"):
        switch_to_tty("5")
        try_login("5", "${mysqlUsername}", "wrongpassword")

        machine.wait_until_tty_matches("5", "Login incorrect")
        machine.wait_until_tty_matches("5", "login:")
  '';
}
