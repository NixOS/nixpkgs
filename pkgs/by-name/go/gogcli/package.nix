{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  testers,
}:

buildGo127Module (finalAttrs: {
  pname = "gogcli";
  version = "0.48.1";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jsyXBhLTImA1pIQ/MyHrq672Sp+glj3pYbmxMMRKXd8=";
  };

  vendorHash = "sha256-18pPtme/0QoeX1PkCdlhWStX3MYJT83ULHSJI3RIOlo=";

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
