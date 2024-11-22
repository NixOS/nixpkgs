addDleynaConnectorPath () {
    if test -d "$1/lib/dleyna-1.0/connectors"
    then
        export DLEYNA_CONNECTOR_PATH="${DLEYNA_CONNECTOR_PATH-}${DLEYNA_CONNECTOR_PATH:+:}$1/lib/dleyna-1.0/connectors"
    fi
}

addEnvHooks "$targetOffset" addDleynaConnectorPath
