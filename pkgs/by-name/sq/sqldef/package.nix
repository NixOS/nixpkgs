{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.17.24";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-hX7qQMmrRmIcVCsNysb+Aj1SV+PEI4ezAlt1OucN8VE=";
  };

  proxyVendor = true;

  vendorHash = "sha256-R4PTgqx8PmW5WJxt5Hdc7JfYD+93J6MPFGRddZxp2dg=";

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
