{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gopodder";
  version = "1.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cbrgm";
    repo = "gopodder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e+d2/1yAhUc88Hn8lAACfK3LGhGiPxQX+FjzNQc6Wqk=";
  };

  vendorHash = "sha256-3SJbVflgwhIw2JmWoKUVjVL8fXWHfYXlm7iI3hYbTpE=";

  ldflags = [
    "-s"
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Self-hostable podcast synchronization server compatible with the gPodder API";
    homepage = "https://github.com/cbrgm/gopodder";
    changelog = "https://github.com/cbrgm/gopodder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nielmin ];
    mainProgram = "gopodder";
  };
})
