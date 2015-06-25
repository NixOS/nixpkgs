{ config, pkgs }:

# Adapted from https://gist.github.com/leehambley/9741431695da3787f6b3

if config.datasource.name != null then
  let
    datasource = config.datasource // { isDefault = true; };
  in
  ''
  PATH=${pkgs.curl}/bin:$PATH

  COOKIEJAR=$(mktemp)
  trap 'unlink $COOKIEJAR' EXIT

  GRAFANA_URL="http://${config.addr}:${toString config.port}"

  until curl -s -o /dev/null $GRAFANA_URL 2>&1; do
    sleep 1;
  done

  function error_exit {
    echo $1
    exit 1
  }

  function setup_grafana_session {
    if ! curl -H 'Content-Type: application/json;charset=UTF-8' \
        --data-binary '{"user":"${config.security.adminUser}","email":"","password":"${config.security.adminPassword}"}' \
        --cookie-jar "$COOKIEJAR" \
        --silent \
        "$GRAFANA_URL/login"  ; then
        echo
        error_exit "Grafana Session: Couldn't store cookies at $COOKIEJAR"
    fi
  }

  function grafana_has_data_source {
      curl --silent --cookie "$COOKIEJAR" "$GRAFANA_URL/api/datasources" \
      | grep "\"name\":\"${datasource.name}\"" --silent
  }

  function grafana_create_data_source {
      curl --cookie "$COOKIEJAR" \
      -X PUT \
      --silent \
      -H 'Content-Type: application/json;charset=UTF-8' \
      --data-binary '${builtins.toJSON datasource}' \
      "$GRAFANA_URL/api/datasources"  | grep 'Datasource added' --silent;
  }

  function setup_grafana {
    setup_grafana_session
    if grafana_has_data_source ; then
      echo "Grafana: Data source ${datasource.name} already exists"
    else
      if grafana_create_data_source ; then
        echo "Grafana: Data source ${datasource.name} created"
      else
        error_exit "Grafana: Data source ${datasource.name} could not be created"
      fi
    fi
  }

  setup_grafana
  ''

else
  ""
