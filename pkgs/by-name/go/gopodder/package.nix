{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gopodder";
  version = "1.4.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cbrgm";
    repo = "gopodder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yu9cbUoorRUnerUKH6ShYMw2RAXdluucJk8uyWIx2FA=";
  };

  vendorHash = "sha256-3hhXSwnS+NaonupkVuCy9uVUTnYBEXHpinWnYNF0UxI=";

  dontPatchELF = true;

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
    "-X main.Revision=${finalAttrs.src.tag}"
    "-X main.BuildDate=1970-01-01"
  ];

  env.CGO_ENABLED = 0;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hostable podcast synchronization server compatible with the gPodder API";
    homepage = "https://github.com/cbrgm/gopodder";
    changelog = "https://github.com/cbrgm/gopodder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nielmin ];
    mainProgram = "gopodder";
  };
})
