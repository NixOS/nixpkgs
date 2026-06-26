{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gogcli";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JunPpEzbNp00uEiJ7AzouXyzFwyNLehLU7mwL3eh4bM=";
  };

  vendorHash = "sha256-JrRIUYpw2lAD0ezi0HTZvS42OS7vP8DAHU3m0u3eCbM=";

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
