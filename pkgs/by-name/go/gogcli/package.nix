{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gogcli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hJU40ysjRx4p9SWGmbhhpToYCpk3DcMAWCnKqxHRmh0=";
  };

  vendorHash = "sha256-WGRlv3UsK3SVBQySD7uZ8+FiRl03p0rzjBm9Se1iITs=";

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
    homepage = "https://github.com/steipete/gogcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "gog";
  };
})
