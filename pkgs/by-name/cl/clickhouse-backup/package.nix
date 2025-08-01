{
  buildGoModule,
  clickhouse-backup,
  fetchFromGitHub,
  lib,
  testers,
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.6.30";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-9CxmMCtrQlHO9Q7gGMN0mIKVERjdef9IB6YUXXuJxeg=";
  };

  vendorHash = "sha256-tv5UaHoZTEAjo0jgbHRZHN6xiCNaexED+NG7cBDtiWA=";

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
