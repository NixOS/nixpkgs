{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-dynamic-dns";
  version = "4.5.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    tag = finalAttrs.version;
    hash = "sha256-JdCfGZIaJl/YqACK7qgc8netAppFSQLu2A7yfBmyO4Y=";
  };

  vendorHash = "sha256-pmiy0Apk51n8bLtzI/OCfemV+44FFV8H9g4fGdynlkE=";

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
