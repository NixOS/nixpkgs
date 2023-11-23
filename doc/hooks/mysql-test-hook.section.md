
# `mysqlTestHook` {#sec-mysqlTestHook}

This hook starts a MariaDB server during the `checkPhase`. Example:

```nix
{ stdenv, mariadb, mysqlTestHook }:
stdenv.mkDerivation {

  # ...

  nativeCheckInputs = [
    mariadb
    mysqlTestHook
  ];
}
```

If you use a custom `checkPhase`, remember to add the `runHook` calls:
```nix
  checkPhase ''
    runHook preCheck

    # ... your tests

    runHook postCheck
  ''
```

## Variables {#sec-mysqlTestHook-variables}

The hook logic will read a number of variables and set them to a default value if unset or empty.

Exported variables:

 - `MYSQL_DATADIR`: location of server files.
 - `MYSQL_UNIX_PORT`: location of UNIX domain socket directory; the default for localhost connections.
 - `MYSQL_USER`: user to create / log in with, default: `test_user`.
 - `MYSQL_DATABASE`: database name, default: `test_db`.

Bash-only variables:

 - `mysqlTestUserOptions`: SQL options to use when creating the `$MYSQL_USER` user. Example: `"IDENTIFIED BY 'password'"`
 - `mysqlTestSetupSQL`: SQL commands to run as database administrator after startup, default: statements that create `$MYSQL_USER` and `$MYSQL_DATABASE`.
 - `mysqlTestSetupCommands`: bash commands to run after database start, defaults to running `$mysqlTestSetupSQL` as database administrator.
 - `mysqlStartCommands`: defaults to `mysqld`.

## Hooks {#sec-mysqlTestHook-hooks}

A number of additional hooks are ran in mysqlTestHook

 - `mysqlTestSetupPost`: ran after mysql has been set up.
