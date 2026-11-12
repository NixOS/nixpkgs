{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-dynamic-dns";
  version = "4.5.15";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    tag = finalAttrs.version;
    hash = "sha256-gWOFnv/MekcPR2F14tZwtzrw6NM4X7yJ6Ji3QhzXcx8=";
  };

  vendorHash = "sha256-X7cs5Wq7ZrUQj9jb9CnPDl4M6Se9BiNDuvfnycXu3QU=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=nixpkg-${finalAttrs.version}"
    "-X=main.date=1970-01-01"
  ];

  env.CGO_ENABLED = 0;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/Zebradil/cloudflare-dynamic-dns/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Dynamic DNS client for Cloudflare";
    homepage = "https://github.com/Zebradil/cloudflare-dynamic-dns";
    license = lib.licenses.mit;
    mainProgram = "cloudflare-dynamic-dns";
    maintainers = [ lib.maintainers.zebradil ];
  };
})
