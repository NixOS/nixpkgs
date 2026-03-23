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
  version = "2.6.43";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1A14tWehOZkmwpuciOxbpKKQbaaOGXh+I8PnqDoCNIE=";
  };

  vendorHash = "sha256-pIbQzXTKsfZeIdwS+/4wG2IA0LCTPaP4mDsxKNtcAuU=";

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
