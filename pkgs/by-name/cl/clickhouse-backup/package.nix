{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ps,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "clickhouse-backup";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HlVngChgU+Do6e5gfP1fg1R/fSGfB8kjG2Ul+N7eJkE=";
  };

  vendorHash = "sha256-HN0H2YFj7k/T2ff1GCrjfE9PO6MtdR/SWKZL/FoqHZ8=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
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
})
