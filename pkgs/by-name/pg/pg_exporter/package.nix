{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGo127Module (finalAttrs: {
  pname = "pg_exporter";
  version = "1.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pgsty";
    repo = "pg_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6j8plIpBOXCb0oNSC6qyKLxtB38nlxQ4K6GzXY9APJk=";
  };

  vendorHash = "sha256-sncGKHs+p+btdJd8CU3q3hn4FNhMIioJxzh/O6JG3A4=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  doInstallCheck = true;
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
