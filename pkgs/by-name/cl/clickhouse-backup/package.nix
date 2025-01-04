{
  buildGoModule,
  clickhouse-backup,
  fetchFromGitHub,
  lib,
  testers,
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-e5PeMe4mk91PpEP0f+08Hr+Q97WfVGE7PDN4DI+9Quw=";
  };

  vendorHash = "sha256-2F3H+Sbrw4Q782Y6gE3KvnXXmiZdSLrJr6AVBHSg9gA=";

  ldflags = [
    "-X main.version=${version}"
  ];

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  passthru.tests.version = testers.testVersion {
    package = clickhouse-backup;
  };

  meta = with lib; {
    description = "Tool for easy ClickHouse backup and restore using object storage for backup files";
    mainProgram = "clickhouse-backup";
    homepage = "https://github.com/Altinity/clickhouse-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
  };
}
