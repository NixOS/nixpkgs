{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sqldef";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6z73BmddtPrqbaWnDSTMeyECMomwHFtLRqIS08UfaLY=";
  };

  proxyVendor = true;

  vendorHash = "sha256-XSb3nMUv2JngkvvjpqfStFXJQFrCaSSTkYaKDGaFfuE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
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
    changelog = "https://github.com/sqldef/sqldef/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ kgtkr ];
  };
})
