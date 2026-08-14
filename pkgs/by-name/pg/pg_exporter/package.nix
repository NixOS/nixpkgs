{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "pg_exporter";
  version = "1.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pgsty";
    repo = "pg_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HDXs4yUeFmdITQATIxg6uRXHlgmA6yy1hA9Zasvk/zs=";
  };

  vendorHash = "sha256-XYgRwYKar/sqMCSnJ865FsM55mCVanbXrZ6aTf6Ksvc=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced PostgreSQL & Pgbouncer Metrics Exporter for Prometheus";
    homepage = "https://pigsty.io/docs/pg_exporter";
    changelog = "https://github.com/pgsty/pg_exporter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "pg_exporter";
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
