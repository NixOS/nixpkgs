preCheckHooks+=('mysqlStart')
postCheckHooks+=('mysqlStop')


mysqlStart() {
  if [[ "${MYSQL_DATADIR:-}" == "" ]]; then
    MYSQL_DATADIR="$NIX_BUILD_TOP/mysql"
  fi

  if [[ "${MYSQL_UNIX_PORT:-}" == "" ]]; then
    mkdir -p "$NIX_BUILD_TOP/tmp"
    MYSQL_UNIX_PORT="$NIX_BUILD_TOP/tmp/mysql.sock"
  fi
  export MYSQL_UNIX_PORT

  if [[ "${MYSQL_USER:-}" == "" ]]; then
    MYSQL_USER="test_user"
  fi
  export MYSQL_USER

  if [[ "${MYSQL_DATABASE:-}" == "" ]]; then
    MYSQL_DATABASE="test_db"
  fi
  export MYSQL_DATABASE

  if [[ "${mysqlTestSetupSQL:-}" == "" ]]; then
    mysqlTestSetupSQL="$(cat <<EOF
      CREATE USER $MYSQL_USER $mysqlTestUserOptions;
      CREATE DATABASE $MYSQL_DATABASE;
      GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* to $MYSQL_USER;
      FLUSH PRIVILEGES;
EOF
    )"
  fi

  if [[ "${mysqlTestSetupCommands:-}" == "" ]]; then
    mysqlTestSetupCommands='echo "$mysqlTestSetupSQL" | mysql'
  fi

  if ! type mysql_install_db >/dev/null; then
    echo >&2 'mysql_install_db not found. Did you add mariadb to the nativeCheckInputs?'
    false
  fi
  echo 'initializing mysql'
  mysql_install_db --datadir="$MYSQL_DATADIR" --user="$(id -u -n)"

  echo 'starting mysql'
  eval "${mysqlStartCommands:-mysqld --datadir="$MYSQL_DATADIR" --socket="$MYSQL_UNIX_PORT"}" &
  while ! test -S "$MYSQL_UNIX_PORT"; do
      sleep 1
  done

  echo 'setting up mysql'
  eval "$mysqlTestSetupCommands"

  runHook mysqlTestSetupPost
}

mysqlStop() {
  echo 'stopping mysql'
  mysqladmin shutdown
}
