{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sqldef";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JUZwBy9aP649HSMLFIB7xrXlqc78JM3B+Ejci1pu+4E=";
  };

  proxyVendor = true;

  vendorHash = "sha256-xX4ZrhIdHvNFRTXHkZfEbevauuv4x9IYfDVfq7IFDg8=";

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
