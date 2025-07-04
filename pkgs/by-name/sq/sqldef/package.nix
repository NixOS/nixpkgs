{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqldef";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "sqldef";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-oko+JJkXqFVnUO15NGJV+Vc/MnuVNwhr+Ck0jMpQ0QY=";
  };

  proxyVendor = true;

  vendorHash = "sha256-SkYRt/w8/YC6LGoADVRdyYdQw/Lves1rd4tl8lYNSSs=";

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
