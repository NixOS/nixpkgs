{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  testers,
}:

buildGo127Module (finalAttrs: {
  pname = "gogcli";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JAIN0MaQegHkg1zBsIYf2YIh3VyeFvQdvyXe9U9AZjg=";
  };

  vendorHash = "sha256-6+/8FVPtrRdE1Hn/MkneZWUiOD/fnQkGYG/T/KD8Du8=";

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
