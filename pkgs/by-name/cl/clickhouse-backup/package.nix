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
  version = "2.6.42";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v2SezQwMgDkS+dAhj122P//CaVIwbqdjlLBvkW3Xkh0=";
  };

  vendorHash = "sha256-vEsbS5aa2+2xiUU96dwn697hW0QA5IGxYD8ua1bsVyw=";

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
