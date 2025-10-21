{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqldef";
  version = "3.1.16";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-Ll0yZ441WeBfCGOmsplN4907q3XQ7hVecwbu6YTC46I=";
  };

  proxyVendor = true;

  vendorHash = "sha256-nLKldyh2p3MA7Ka3YzrafLbxKxdxKQVnMQVhTpNVdXI=";

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
