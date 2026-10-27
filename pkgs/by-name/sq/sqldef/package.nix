{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sqldef";
  version = "3.11.27";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VZtmbtrLzsH1mSNSoscQpwqRR1E3Aqa5nZW9nExtD8Y=";
  };

  proxyVendor = true;

  vendorHash = "sha256-43npuT7Vq5xou+TlCEjkvpVxeNEmQc0WmLP8HK4CzF0=";

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
