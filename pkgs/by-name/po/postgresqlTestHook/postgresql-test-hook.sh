preCheckHooks+=(postgresqlStart)
postCheckHooks+=(postgresqlStop)


postgresqlStart() {

  # Add default environment variable values
  #
  # Client variables:
  #  - https://www.postgresql.org/docs/current/libpq-envars.html
  #
  # Server variables:
  #  - only PGDATA: https://www.postgresql.org/docs/current/creating-cluster.html

  if [[ "${PGDATA:-}" == "" ]]; then
    PGDATA="$NIX_BUILD_TOP/postgresql"
  fi
  export PGDATA

  if [[ "${PGHOST:-}" == "" ]]; then
    mkdir -p "$NIX_BUILD_TOP/run/postgresql"
    PGHOST="$NIX_BUILD_TOP/run/postgresql"
  fi
  export PGHOST

  if [[ "${PGUSER:-}" == "" ]]; then
    PGUSER="test_user"
  fi
  export PGUSER

  if [[ "${PGDATABASE:-}" == "" ]]; then
    PGDATABASE="test_db"
  fi
  export PGDATABASE

  if [[ "${postgresqlTestUserOptions:-}" == "" ]]; then
    postgresqlTestUserOptions="LOGIN"
  fi

  if [[ "${postgresqlTestSetupSQL:-}" == "" ]]; then
    postgresqlTestSetupSQL="$(cat <<EOF
      CREATE ROLE "$PGUSER" $postgresqlTestUserOptions;
      CREATE DATABASE "$PGDATABASE" OWNER '$PGUSER';
EOF
    )"
  fi

  if [[ "${postgresqlTestSetupCommands:-}" == "" ]]; then
    postgresqlTestSetupCommands='echo "$postgresqlTestSetupSQL" | PGUSER=postgres psql postgres'
  fi

  if ! type initdb >/dev/null; then
    echo >&2 'initdb not found. Did you add postgresql to the nativeCheckInputs?'
    false
  fi
  echo 'initializing postgresql'
  initdb -U postgres

  echo "$postgresqlExtraSettings" >>"$PGDATA/postgresql.conf"

  # Move the socket
  echo "unix_socket_directories = '$NIX_BUILD_TOP/run/postgresql'" >>"$PGDATA/postgresql.conf"

  # TCP ports can be a problem in some sandboxes,
  # so we disable tcp listening by default
  if ! [[ "${postgresqlEnableTCP:-}" = 1 ]]; then
    echo "listen_addresses = ''" >>"$PGDATA/postgresql.conf"
  fi

  echo 'starting postgresql'
  eval "${postgresqlStartCommands:-pg_ctl start}"
  failureHooks+=(postgresqlStop)

  echo 'setting up postgresql'
  eval "$postgresqlTestSetupCommands"

  runHook postgresqlTestSetupPost

}

postgresqlStop() {
  echo 'stopping postgresql'
  pg_ctl stop
  failureHooks=("${failureHooks[@]/postgresqlStop}")
}
