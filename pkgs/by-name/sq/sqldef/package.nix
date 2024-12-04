{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.17.23";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-hknfPVOtxs2Hv4GrbIM1tyrmJHWnK86qdD1FQUmpk10=";
  };

  proxyVendor = true;

  vendorHash = "sha256-N9+theiJnDP8Nbe0pcEPpjYcy2YVyueF8Q2bdLCCbEc=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # The test requires a running database
  doCheck = false;

  meta = {
    description = "Idempotent SQL schema management tool";
    license = with lib.licenses; [ mit /* for everything except parser */ asl20 /* for parser */ ];
    homepage = "https://github.com/sqldef/sqldef";
    changelog = "https://github.com/sqldef/sqldef/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ kgtkr ];
  };
}
