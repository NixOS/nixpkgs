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

  # Errors:
  #  > === RUN   TestNamespaceHandlerGlobalNamespaceDisabledSuite
  # gocql: unable to dial control conn 127.0.0.1:9042: dial tcp 127.0.0.1:9042: connect: connection refused
  doCheck = false;

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
