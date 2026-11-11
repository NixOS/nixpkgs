{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  testers,
}:

buildGo127Module (finalAttrs: {
  pname = "gogcli";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IQq1fOEtPWaGVCoYiKEfhNUz5kaGgOjAr/7GwiGZnlg=";
  };

  vendorHash = "sha256-pvmn4tRoom5Y9z8w6bY9YaEbEybae4cjBrdB20qF8/Q=";

  subPackages = [ "cmd/gog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openclaw/gogcli/internal/cmd.version=v${finalAttrs.version}"
    "-X github.com/openclaw/gogcli/internal/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/openclaw/gogcli/internal/cmd.date=1970-01-01T00:00:00Z"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "gog --version";
    version = "v${finalAttrs.version} (${finalAttrs.src.rev} 1970-01-01T00:00:00Z)";
  };

  meta = {
    description = "CLI tool for interacting with Google APIs (Gmail, Calendar, Drive, and more)";
    homepage = "https://github.com/openclaw/gogcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      macalinao
      rschaffar
    ];
    mainProgram = "gog";
  };
})
