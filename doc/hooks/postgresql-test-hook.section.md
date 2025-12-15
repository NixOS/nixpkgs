
# `postgresqlTestHook` {#sec-postgresqlTestHook}

This hook starts a PostgreSQL server during the `checkPhase`. Example:

```nix
{
  stdenv,
  postgresql,
  postgresqlTestHook,
}:
stdenv.mkDerivation {

  # ...

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
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

## Variables {#sec-postgresqlTestHook-variables}

The hook logic will read a number of variables and set them to a default value if unset or empty.

Exported variables:

 - `PGDATA`: location of server files.
 - `PGHOST`: location of UNIX domain socket directory; the default `host` in a connection string.
 - `PGUSER`: user to create / log in with, default: `test_user`.
 - `PGDATABASE`: database name, default: `test_db`.

Bash-only variables:

 - `postgresqlTestUserOptions`: SQL options to use when creating the `$PGUSER` role, default: `"LOGIN"`. Example: `"LOGIN SUPERUSER"`
 - `postgresqlTestSetupSQL`: SQL commands to run as database administrator after startup, default: statements that create `$PGUSER` and `$PGDATABASE`.
 - `postgresqlTestSetupCommands`: bash commands to run after database start, defaults to running `$postgresqlTestSetupSQL` as database administrator.
 - `postgresqlEnableTCP`: set to `1` to enable TCP listening. Flaky; not recommended.
 - `postgresqlStartCommands`: defaults to `pg_ctl start`.
 - `postgresqlExtraSettings`: Additional configuration to add to `postgresql.conf`

## Hooks {#sec-postgresqlTestHook-hooks}

A number of additional hooks are run in postgresqlTestHook

 - `postgresqlTestSetupPost`: run after postgresql has been set up.

## TCP and the Nix sandbox {#sec-postgresqlTestHook-tcp}

`postgresqlEnableTCP` relies on network sandboxing, which is not available on macOS and some custom Nix installations, resulting in flaky tests.
For this reason, it is disabled by default.

The preferred solution is to make the test suite use a UNIX domain socket connection. This is the default behavior when no `host` connection parameter is provided.
Some test suites hardcode a value for `host` though, so a patch may be required. If you can upstream the patch, you can make `host` default to the `PGHOST` environment variable when set. Otherwise, you can patch it locally to omit the `host` connection string parameter altogether.

::: {.note}
The error `libpq: failed (could not receive data from server: Connection refused` is generally an indication that the test suite is trying to connect through TCP.
:::
