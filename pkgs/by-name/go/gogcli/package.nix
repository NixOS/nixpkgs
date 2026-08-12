{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gogcli";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KEytK68g0+MqpcY/R9Wr89tJB7EG6wnmKQAqYWZ/VJU=";
  };

  vendorHash = "sha256-F1D3ax+xiTlhsYLgoe/K8x2VQKG9iHZ5FNJJ9YDkEV0=";

  subPackages = [ "cmd/gog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/steipete/gogcli/internal/cmd.version=v${finalAttrs.version}"
    "-X github.com/steipete/gogcli/internal/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/steipete/gogcli/internal/cmd.date=1970-01-01T00:00:00Z"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "gog --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "CLI tool for interacting with Google APIs (Gmail, Calendar, Drive, and more)";
    homepage = "https://github.com/openclaw/gogcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "gog";
  };
})
