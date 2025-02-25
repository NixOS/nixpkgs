{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqldef";
  version = "0.17.32";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-xGFepNalT2UIIFYh9BQnFzvC1SxlcLDxMX+zGEutD+I=";
  };

  proxyVendor = true;

  vendorHash = "sha256-AKYmE/nysDYyYsqfFleOpWw8DEp/587XI/NA1gv20BU=";

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
