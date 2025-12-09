{
  buildGoModule,
  clickhouse-backup,
  fetchFromGitHub,
  lib,
  testers,
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.6.41";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-o7twdOyd53rP95Pi+l5MIo+U/lDqB0cynqONokfy8do=";
  };

  vendorHash = "sha256-UxbQ/Q4HsTBkbIMBdeKns6t8tZnfdBRaHDMOA2RYDLI=";

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
