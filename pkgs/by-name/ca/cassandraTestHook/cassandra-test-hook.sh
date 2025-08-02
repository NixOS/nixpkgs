preCheckHooks+=('cassandraStart')
postCheckHooks+=('cassandraStop')

cassandraStart() {
    HOME="$NIX_BUILD_TOP/.home"

    if ! type cassandra >/dev/null; then
        echo >&2 'cassandra not found. Did you add cassandra to the nativeCheckInputs?'
        false
    fi

    # Set default environment variables
    if [[ "${CASSANDRA_DATA_DIR:-}" == "" ]]; then
        CASSANDRA_DATA_DIR="$NIX_BUILD_TOP/cassandra_data"
    fi
    export CASSANDRA_DATA_DIR

    if [[ "${CASSANDRA_CONF_DIR:-}" == "" ]]; then
        CASSANDRA_CONF_DIR="$NIX_BUILD_TOP/cassandra_conf"
    fi
    export CASSANDRA_CONF_DIR

    if [[ "${CASSANDRA_LOG_DIR:-}" == "" ]]; then
        CASSANDRA_LOG_DIR="$NIX_BUILD_TOP/cassandra_log"
    fi
    export CASSANDRA_LOG_DIR

    mkdir -p "$CASSANDRA_DATA_DIR" "$CASSANDRA_CONF_DIR" "$CASSANDRA_LOG_DIR"

    cat >"$CASSANDRA_CONF_DIR/cassandra.yaml" <<EOF
    cluster_name: 'TestCluster'
    num_tokens: 1

    listen_address: 127.0.0.1
    rpc_address: 127.0.0.1
    broadcast_rpc_address: 127.0.0.1

    data_file_directories:
    - ${CASSANDRA_DATA_DIR}/data
    commitlog_directory: ${CASSANDRA_DATA_DIR}/commitlog
    saved_caches_directory: ${CASSANDRA_DATA_DIR}/saved_caches
    hints_directory: ${CASSANDRA_DATA_DIR}/hints

    start_native_transport: true
    native_transport_port: 9042
    storage_port: 7000
    ssl_storage_port: 7001

    authenticator: AllowAllAuthenticator
    authorizer: AllowAllAuthorizer
    role_manager: CassandraRoleManager

    seed_provider:
        - class_name: org.apache.cassandra.locator.SimpleSeedProvider
          parameters:
            - seeds: "127.0.0.1"

    endpoint_snitch: SimpleSnitch

    # Required directive
    commitlog_sync: periodic
    commitlog_sync_period_in_ms: 10000
    partitioner: org.apache.cassandra.dht.Murmur3Partitioner
EOF

    echo "starting cassandra"
    cassandra -f -Dcassandra.config=file://$CASSANDRA_CONF_DIR/cassandra.yaml
    CASSANDRA_PID=$!
    export CASSANDRA_PID

    echo 'waiting for cassandra to be available'
    for i in {1..30}; do
        if cqlsh -e 'DESCRIBE KEYSPACES' 127.0.0.1 2>/dev/null; then
            echo "Cassandra is ready"
            break
        fi
        sleep 1
    done

    if [[ "${cassandraTestSetupCommands:-}" != "" ]]; then
        echo 'setting up cassandra'
        eval "$cassandraTestSetupCommands"
    fi

    runHook cassandraTestSetupPost
}

cassandraStop() {
    echo 'stopping cassandra'
    kill "$CASSANDRA_PID"
    wait "$CASSANDRA_PID" 2>/dev/null || true
}
