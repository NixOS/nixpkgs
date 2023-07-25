{ lib, fetchFromGitHub, buildGoModule, testers, temporal }:

buildGoModule rec {
  pname = "temporal";
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    rev = "v${version}";
    hash = "sha256-4iosKxGjH2O2y2wkAs/tuCH+SXTj6FhrPqS9qgL+vTQ=";
  };

  vendorHash = "sha256-rgUdoFR7Qcp1h7v63DAWwx6NWSwWrJ6C6/b2tx2kCCw=";

  excludedPackages = [ "./build" ];

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  # There too many integration tests.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ./schema $out/share/

    install -Dm755 "$GOPATH/bin/server" -T $out/bin/temporal-server
    install -Dm755 "$GOPATH/bin/cassandra" -T $out/bin/temporal-cassandra-tool
    install -Dm755 "$GOPATH/bin/sql" -T $out/bin/temporal-sql-tool
    install -Dm755 "$GOPATH/bin/tdbg" -T $out/bin/tdbg

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = temporal;
  };

  meta = with lib; {
    description = "A microservice orchestration platform which enables developers to build scalable applications without sacrificing productivity or reliability";
    homepage = "https://temporal.io";
    changelog = "https://github.com/temporalio/temporal/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ titanous ];
    mainProgram = "temporal-server";
  };
}
