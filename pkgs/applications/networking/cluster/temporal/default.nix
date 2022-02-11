{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "temporal";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    rev = "v${version}";
    sha256 = "1gdks7pzaqrsdihh2m3v597x0dw2qww95jlznj0h112jgicanimj";
  };

  vendorSha256 = "sha256-dGmd6tCUKoK4uwhB5kXGOpXemtLn0VssabDE4iQWEAw=";

  # Errors:
  #  > === RUN   TestNamespaceHandlerGlobalNamespaceDisabledSuite
  # gocql: unable to dial control conn 127.0.0.1:9042: dial tcp 127.0.0.1:9042: connect: connection refused
  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cli" -T $out/bin/tctl
    install -Dm755 "$GOPATH/bin/cassandra" -T $out/bin/temporal-cassandra
    install -Dm755 "$GOPATH/bin/server" -T $out/bin/temporal-server
    install -Dm755 "$GOPATH/bin/sql" -T $out/bin/temporal-sql
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/tctl --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A microservice orchestration platform which enables developers to build scalable applications without sacrificing productivity or reliability";
    downloadPage = "https://github.com/temporalio/temporal";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
