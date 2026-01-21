{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ps,
  stdenv,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.6.41";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    tag = "v${version}";
    hash = "sha256-LBwmdGcQuDu0tr9c67bboBzv6ypxzYRU36Z76lL94yo=";
  };

  vendorHash = "sha256-UxbQ/Q4HsTBkbIMBdeKns6t8tZnfdBRaHDMOA2RYDLI=";

  ldflags = [
    "-X main.version=${version}"
  ];

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  preCheck = ''
    export PATH=${ps}/bin:$PATH
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-skip=TestParseCallback" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Tool for easy ClickHouse backup and restore using object storage for backup files";
    mainProgram = "clickhouse-backup";
    homepage = "https://github.com/Altinity/clickhouse-backup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
  };
}
