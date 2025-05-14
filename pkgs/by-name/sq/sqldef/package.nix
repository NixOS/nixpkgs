{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqldef";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-tCKJ0iX0cWWdw+RSH15KTVDEcrZhbfZg+dgt/swDSJE=";
  };

  proxyVendor = true;

  vendorHash = "sha256-1LpDM4XYV2k7d8vFx97AuZSVpClTvNU5ezXnbhOkkP0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # The test requires a running database
  doCheck = false;

  meta = {
    description = "Idempotent SQL schema management tool";
    license = with lib.licenses; [
      mit # for everything except parser
      asl20 # for parser
    ];
    homepage = "https://github.com/sqldef/sqldef";
    changelog = "https://github.com/sqldef/sqldef/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ kgtkr ];
  };
}
