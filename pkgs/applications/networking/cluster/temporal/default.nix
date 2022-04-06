{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "temporal";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    rev = "v${version}";
    sha256 = "sha256-5Tu838086qgIa2fqda2xi7vn4JbkENVJH4XU3NwW7Ic=";
  };

  vendorSha256 = "sha256-caRBgkuHQ38r6OsKQCJ2pxAe8s6mc4g/QCIsCEXvY3M=";

  postPatch = ''
    substituteInPlace common/namespace/handler_GlobalNamespaceDisabled_test.go \
      --replace "TestNamespaceHandlerGlobalNamespaceDisabledSuite" \
                "SkipNamespaceHandlerGlobalNamespaceDisabledSuite"

    substituteInPlace common/namespace/handler_GlobalNamespaceEnabled_MasterCluster_test.go \
      --replace "TestNamespaceHandlerGlobalNamespaceEnabledMasterClusterSuite" \
                "SkipNamespaceHandlerGlobalNamespaceEnabledMasterClusterSuite"

    substituteInPlace common/namespace/handler_GlobalNamespaceEnabled_NotMasterCluster_test.go \
      --replace "TestNamespaceHandlerGlobalNamespaceEnabledNotMasterClusterSuite" \
                "SkipNamespaceHandlerGlobalNamespaceEnabledNotMasterClusterSuite"

    substituteInPlace common/namespace/handler_test.go \
      --replace "TestNamespaceHandlerCommonSuite" \
                "SkipNamespaceHandlerCommonSuite"

    substituteInPlace common/namespace/replicationTaskExecutor_test.go \
      --replace "TestNamespaceReplicationTaskExecutorSuite" \
                "SkipNamespaceReplicationTaskExecutorSuite"

    rm common/persistence/persistence-tests/cassandra_test.go
    rm common/persistence/persistence-tests/mysql_test.go
    rm common/persistence/persistence-tests/postgres_test.go
    rm common/persistence/sql/sqlplugin/tests/mysql_test.go
    rm common/persistence/sql/sqlplugin/tests/postgresql_test.go
    rm common/persistence/tests/cassandra_test.go
    rm common/persistence/tests/mysql_test.go
    rm common/persistence/tests/postgresql_test.go
    rm common/persistence/visibility/persistence-tests/cassandra_test.go
    rm common/persistence/visibility/persistence-tests/postgrsql_test.go
    rm common/persistence/visibility/persistence-tests/mysql_test.go
    rm tools/sql/clitest/mysql_cli_test.go
    rm tools/sql/clitest/postgresql_cli_test.go

    substituteInPlace host/client_integration_test.go \
      --replace "TestClientIntegrationSuite" "SkipClientIntegrationSuite"

    substituteInPlace host/integration_test.go \
      --replace "TestIntegrationSuite" "SkipIntegrationSuite"

    substituteInPlace host/sizelimit_test.go \
      --replace "TestSizeLimitIntegrationSuite" "SkipSizeLimitIntegrationSuite"

    substituteInPlace host/ndc/ndc_integration_test.go \
      --replace "TestNDCIntegrationTestSuite" "SkipNDCIntegrationTestSuite"

    substituteInPlace host/xdc/integration_failover_test.go \
      --replace "TestIntegrationClustersTestSuite" "SkipIntegrationClustersTestSuite"

    substituteInPlace tests/integration/cassandra_test.go \
      --replace "TestCassandraSizeLimitSuite" "SkipCassandraSizeLimitSuite"

    substituteInPlace tests/integration/mysql_test.go \
      --replace "TestMySQLSizeLimitSuite" "SkipMySQLSizeLimitSuite"

    substituteInPlace tests/integration/postgresql_test.go \
      --replace "TestPostgreSQLSizeLimitSuite" "SkipPostgreSQLSizeLimitSuite"

    substituteInPlace tools/cassandra/cqlclient_test.go \
      --replace "TestCQLClientTestSuite" "SkipCQLClientTestSuite"

    substituteInPlace tools/cassandra/setupTask_test.go \
      --replace "TestSetupSchemaTestSuite" "SkipSetupSchemaTestSuite"

    substituteInPlace tools/cassandra/updateTask_test.go \
      --replace "TestUpdateSchemaTestSuite" "SkipUpdateSchemaTestSuite"

    substituteInPlace tools/cassandra/version_test.go \
      --replace "TestVersionTestSuite" "SkipVersionTestSuite"

    substituteInPlace tools/common/schema/version_test.go \
      --replace "TestSetupSchemaTestSuite" "SkipSetupSchemaTestSuite" \
      --replace "TestVersionTestSuite" "SkipVersionTestSuite"

    substituteInPlace service/matching/taskQueueManager_test.go \
      --replace "TestAddTaskStandby" "SkipAddTaskStandby"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cli" -T $out/bin/tctl
    install -Dm755 "$GOPATH/bin/authorization" -T $out/bin/tctl-authorization-plugin
    install -Dm755 "$GOPATH/bin/server" -T $out/bin/temporal-server
    install -Dm755 "$GOPATH/bin/cassandra" -T $out/bin/temporal-cassandra-tool
    install -Dm755 "$GOPATH/bin/sql" -T $out/bin/temporal-sql-tool
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/tctl --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A microservice orchestration platform which enables developers to build scalable applications without sacrificing productivity or reliability";
    homepage = "https://temporal.io";
    changelog = "https://github.com/temporalio/temporal/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ titanous ];
  };
}
