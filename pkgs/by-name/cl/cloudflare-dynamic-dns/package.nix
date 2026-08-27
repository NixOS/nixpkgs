{
  lib,
  buildGoModule,
  cloudflare-dynamic-dns,
  fetchFromGitHub,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-dynamic-dns";
  version = "4.5.5";

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    tag = finalAttrs.version;
    hash = "sha256-+mFApn2ClRXAPY7pSLm9SDw3gibxH5471Y/whn/cQg8=";
  };

  vendorHash = "sha256-7yqvpl6BvDiBMHu4cpoK66t9a5gwtK0PEfkjIHe6fJQ=";

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
