{
  lib,
  buildGoModule,
  cloudflare-dynamic-dns,
  fetchFromGitHub,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-dynamic-dns";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    tag = finalAttrs.version;
    hash = "sha256-G3msehvCZPm5WZTVCN0NnVEApZBQtqxJKCt0SFWb6xk=";
  };

  vendorHash = "sha256-Zdr6XTcblCi+YGhAgo0VqyN25jTGC5yA6YpQJXBCPGc=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=nixpkg-${finalAttrs.version}"
    "-X=main.date=1970-01-01"
  ];

  env.CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = cloudflare-dynamic-dns; };

  meta = {
    changelog = "https://github.com/Zebradil/cloudflare-dynamic-dns/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Dynamic DNS client for Cloudflare";
    homepage = "https://github.com/Zebradil/cloudflare-dynamic-dns";
    license = lib.licenses.mit;
    mainProgram = "cloudflare-dynamic-dns";
    maintainers = [ lib.maintainers.zebradil ];
  };
})
